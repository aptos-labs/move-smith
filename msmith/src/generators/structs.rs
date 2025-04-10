use crate::{
    move_ast::{MoveAST, SingleVariable, Struct, TypeParameters},
    states::{
        get_config_mut, get_type_pool, new_id_from_curr_scope,
        new_id_from_curr_scope_and_push_scope, pop_scope, Ability, IdKind, TypeSelectorBuilder,
    },
};
use anyhow::{Ok, Result};
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct StructGenerator;

impl LabelledGenerator for StructGenerator {
    fn label() -> GenLabel {
        GenLabel::new_module_member_level("StructGenerator")
    }
}

impl Register<GeneratorEntry> for StructGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for StructGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (name, _scope, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Struct);
        let type_params = TypeParameters::default();
        let abilities = vec![Ability::Copy, Ability::Drop, Ability::Store, Ability::Key];

        let config = get_config_mut(env);
        let num_fields = config.num_fields_in_struct.select(u)?;

        let selector = if config.total_num_composite_type_in_struct.incr(u) {
            TypeSelectorBuilder::all_no(config)
                .bool(1)
                .number(1)
                .structs(1)
                .enums(1)
                .build()
        } else {
            TypeSelectorBuilder::all_no(config)
                .bool(1)
                .number(1)
                .build()
        };

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

        let mut positional = bool::arbitrary(u)?;
        if num_fields == 0 {
            // Avoid empty structs being positional
            positional = false;
        }

        let subtree = Subtree::new_single_candidate(
            Struct {
                name,
                type_params,
                abilities,
                fields,
                positional,
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
        ast.as_struct().is_some()
    }
}
