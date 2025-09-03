use crate::{
    generators::{BlockGenerator, ExprOfTypeGenerator},
    move_ast::{Branch, Expression, MoveAST},
    states::{pop_scope, push_scope, Scope, Type},
};
use anyhow::{Ok, Result};
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct BranchGenerator;

impl LabelledGenerator for BranchGenerator {
    fn label() -> GenLabel {
        GenLabel::new("BranchGenerator")
    }
}

impl Register<GeneratorEntry> for BranchGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for BranchGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<Type>("type")
            && constraint.check_not_exist_or_has_type::<Scope>("scope")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let scope = constraint.get::<Scope>("scope");
        if let Some(scope) = scope {
            push_scope(env, scope.clone());
        }

        let mut subtrees = vec![];

        let use_block_as_body = bool::arbitrary(u)?;
        if use_block_as_body {
            subtrees.push(Subtree::new_generator_subtree(
                BlockGenerator::label(),
                constraint.clone().with("is_function_body", false),
            ));
        } else {
            subtrees.push(Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                constraint.clone(),
            ));
        };
        Ok((
            subtrees,
            constraint
                .clone()
                .with("use_block_as_body", use_block_as_body),
        ))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        comp_constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        if comp_constraint.get::<Scope>("scope").is_some() {
            pop_scope(env);
        }
        let use_block_as_body = comp_constraint.get::<bool>("use_block_as_body").unwrap();
        let node = asts.into_iter().next().unwrap();
        let branch_body = if *use_block_as_body {
            let block = node.into_block().unwrap();
            Expression::Block(block)
        } else {
            node.into_expression().unwrap()
        };
        Ok(Branch {
            body: Box::new(branch_body),
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
        ast.as_branch().is_some()
    }
}
