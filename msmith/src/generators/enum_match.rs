use crate::{
    generators::{ExprOfTypeGenerator, MatchArmGenerator},
    move_ast::{EnumMatch, MoveAST, Pattern, PatternKind},
    states::{
        get_complete_patterns_for_enum, get_config, get_curr_scope, new_id_from_curr_scope,
        random_type_from_curr_scope, EnumType, EnumVariantType, GenericType, IdKind, Type,
        TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    selection::choose_indices_subset_shuffled, AnyConstraint, GenLabel, Generator, GeneratorEntry,
    LabelledGenerator, Register, StatePool, Subtree,
};

#[derive(Default)]
pub struct EnumMatchGenerator;

impl LabelledGenerator for EnumMatchGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EnumMatchGenerator")
    }
}

impl Register<GeneratorEntry> for EnumMatchGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EnumMatchGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let correct_enum_expr_type = if let Some(typ) = constraint.get::<Type>("enum") {
            typ.is_enum()
        } else {
            true
        };
        let correct_arm_type = constraint.check_not_exist_or_has_type::<Type>("type");
        correct_enum_expr_type && correct_arm_type
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let mut subtrees = vec![];
        let enum_type = match constraint.get::<Type>("enum") {
            Some(typ) => typ.clone(),
            None => {
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .enums(1)
                    .build();
                random_type_from_curr_scope(u, env, vec![selector])?
            },
        };
        subtrees.push(Subtree::new_generator_subtree(
            ExprOfTypeGenerator::label(),
            AnyConstraint::new().with("type", enum_type.clone()),
        ));

        let arm_type = match constraint.get::<Type>("type") {
            Some(typ) => typ.clone(),
            None => {
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .bool(1)
                    .number(1)
                    .enums(1)
                    .func_return(1)
                    .structs(1)
                    .unit(1)
                    .build();
                random_type_from_curr_scope(u, env, vec![selector])?
            },
        };

        let curr_scope = get_curr_scope(env);
        let ct = match &enum_type {
            Type::Concrete(ct) => ct.get_concretized_type(),
            _ => enum_type.clone(),
        };
        let et = match ct {
            Type::Generic(GenericType::Enum(et)) => et,
            _ => panic!("Expected enum type, found: {ct:?}"),
        };

        let pat_scopes = get_complete_patterns_for_enum(u, env, et.clone(), &curr_scope);
        let chosen_indices = choose_indices_subset_shuffled(u, &pat_scopes, None)?;

        for i in &chosen_indices {
            let (pattern, variant, scope) = pat_scopes[*i].clone();
            let subtree = Subtree::new_generator_subtree(
                MatchArmGenerator::label(),
                constraint
                    .clone()
                    .with("variant_type", variant)
                    .with("pattern", pattern)
                    .with("scope", scope)
                    .with("type", arm_type.clone()),
            );
            subtrees.push(subtree);
        }

        // Some patterns are ignored
        if chosen_indices.len() != pat_scopes.len() {
            let (_, arm_scope) = new_id_from_curr_scope(env, IdKind::Block);
            let subtree = Subtree::new_generator_subtree(
                MatchArmGenerator::label(),
                AnyConstraint::new()
                    .with("variant_type", EnumVariantType::wildcard_variant())
                    .with("pattern", Pattern {
                        typ: enum_type.clone(),
                        body: PatternKind::Wildcard,
                    })
                    .with("scope", arm_scope)
                    .with("type", arm_type.clone()),
            );
            subtrees.push(subtree);
        }

        Ok((
            subtrees,
            AnyConstraint::new()
                .with("type", arm_type)
                .with("enum_type", et),
        ))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let enum_type = constraint.get::<EnumType>("enum_type").unwrap().clone();
        let typ = constraint.get::<Type>("type").unwrap().clone();
        let mut iter = asts.into_iter();
        let expr = iter.next().unwrap().into_expression().unwrap();
        let arms = iter.map(|ast| ast.into_matcharm().unwrap()).collect();
        Ok(EnumMatch {
            enum_type,
            expr: Box::new(expr),
            arms,
            typ,
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_enummatch().is_some()
    }
}
