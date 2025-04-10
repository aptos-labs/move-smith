use crate::{
    move_ast::{Enum, EnumVariant, MoveAST, SingleVariable, TypeParameters},
    states::{
        get_config, get_config_mut, get_type_pool, new_id_from_curr_scope,
        new_id_from_curr_scope_and_push_scope, pop_scope, Ability, IdKind, TypeSelectorBuilder,
    },
};
use anyhow::{Ok, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EnumGenerator;

impl LabelledGenerator for EnumGenerator {
    fn label() -> GenLabel {
        GenLabel::new_module_member_level("EnumGenerator")
    }
}

impl Register<GeneratorEntry> for EnumGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EnumGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (name, _scope, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Enum);
        let type_params = TypeParameters::default();
        let abilities = vec![Ability::Copy, Ability::Drop, Ability::Store, Ability::Key];

        let num_variants = get_config(env).num_variants_in_enum.select(u)?;

        let mut variants = vec![];
        for _ in 0..num_variants {
            let (variant_name, _scope) = new_id_from_curr_scope(env, IdKind::EnumVariant);
            let selector = if get_config_mut(env).total_num_composite_type_in_enum.incr(u) {
                TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .bool(1)
                    .structs(1)
                    .enums(1)
                    .build()
            } else {
                TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .bool(1)
                    .build()
            };
            let num_fields = get_config(env).num_fields_in_enum_variant.select(u)?;

            let mut fields = vec![];
            for _ in 0..num_fields {
                let (field_name, _scope) = new_id_from_curr_scope(env, IdKind::Field);
                let field_type = get_type_pool(env).random_type(u, vec![selector.clone()])?;
                fields.push(SingleVariable {
                    name: field_name,
                    typ: field_type,
                    declare: true,
                    show_type: true,
                });
            }
            let positional = u.arbitrary()?;
            variants.push(EnumVariant {
                name: variant_name,
                fields,
                positional,
            });
        }

        let subtree = Subtree::new_single_candidate(
            Enum {
                name,
                type_params,
                abilities,
                variants,
            }
            .into(),
        );
        pop_scope(env);
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        Ok(asts.into_iter().next().unwrap())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_enum().is_some()
    }
}
