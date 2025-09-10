use crate::{
    generators::SpecPredicateGenerator,
    move_ast::{MoveAST, SpecBlock, SpecContext, SpecPredicate, SpecStatement},
    states::{get_config, new_id_from_curr_scope_and_push_scope, pop_scope, Id, IdKind},
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::trace;

#[derive(Default)]
pub struct SpecBlockGenerator;

impl LabelledGenerator for SpecBlockGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("SpecBlockGenerator")
    }
}

impl Register<GeneratorEntry> for SpecBlockGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for SpecBlockGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<SpecContext>("context")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let context: &SpecContext = constraint.get("context").unwrap();

        let (name, spec_scope, _parent_scope) =
            new_id_from_curr_scope_and_push_scope(env, IdKind::Spec);

        trace!(
            "Generating spec block -- {name}, {spec_scope:?}, context: {:?}",
            context
        );

        let config = get_config(env);
        let num_statements = match context {
            SpecContext::InlineSpec => config.num_stmts_in_inline_spec.select(u)?,
            SpecContext::FunctionSpec { .. } => config.num_stmts_in_function_spec.select(u)?,
        };

        let mut compose_constraint = AnyConstraint::new();
        compose_constraint.insert("name", name.clone());
        compose_constraint.insert("context", context.clone());
        compose_constraint.insert("num_statements", num_statements);

        let mut subtrees = vec![];
        for _ in 0..num_statements {
            subtrees.push(Subtree::new_generator_subtree(
                SpecPredicateGenerator::label(),
                AnyConstraint::new(),
            ));
        }

        Ok((subtrees, compose_constraint))
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        pop_scope(env);

        let name: &Id = constraint.get("name").unwrap();
        let context: &SpecContext = constraint.get("context").unwrap();
        let num_statements: &usize = constraint.get("num_statements").unwrap();

        let mut statements = Vec::new();

        for _ in 0..*num_statements {
            let predicate: SpecPredicate = asts.remove(0).try_into().unwrap();

            let spec_statement = match context {
                SpecContext::InlineSpec => {
                    // For inline specs, randomly choose between assert and assume
                    if bool::arbitrary(u)? {
                        SpecStatement::Assert(predicate)
                    } else {
                        SpecStatement::Assume(predicate)
                    }
                },
                SpecContext::FunctionSpec { .. } => {
                    // For function specs, randomly choose between requires and ensures
                    if bool::arbitrary(u)? {
                        SpecStatement::Requires(predicate)
                    } else {
                        SpecStatement::Ensures(predicate)
                    }
                },
            };

            statements.push(spec_statement);
        }

        Ok(SpecBlock {
            name: name.clone(),
            context: context.clone(),
            statements,
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
        ast.as_specblock().is_some()
    }
}
