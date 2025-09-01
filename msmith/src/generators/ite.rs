use crate::{
    generators::{BranchGenerator, ExprOfTypeGenerator},
    move_ast::{IfElse, MoveAST},
    states::{get_config, random_type_from_curr_scope, Primitive, Type, TypeSelectorBuilder},
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct IfElseGenerator;

impl LabelledGenerator for IfElseGenerator {
    fn label() -> GenLabel {
        GenLabel::new("IfElseGenerator")
    }
}

impl Register<GeneratorEntry> for IfElseGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for IfElseGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<Type>("type")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let mut subtrees = vec![];

        let condition_subtree = Subtree::new_generator_subtree(
            ExprOfTypeGenerator::label(),
            AnyConstraint::new().with("type", Type::Primitive(Primitive::Bool)),
        );
        subtrees.push(condition_subtree);

        // Determine the result type for if-else expression
        let result_type = constraint.get::<Type>("type").cloned().unwrap_or_else(|| {
            let selector = TypeSelectorBuilder::all_yes(get_config(env)).build();
            random_type_from_curr_scope(u, env, vec![selector]).unwrap()
        });

        subtrees.push(Subtree::new_generator_subtree(
            BranchGenerator::label(),
            AnyConstraint::new().with("type", result_type.clone()),
        ));

        let has_else = bool::arbitrary(u)?;

        if has_else {
            subtrees.push(Subtree::new_generator_subtree(
                BranchGenerator::label(),
                AnyConstraint::new().with("type", result_type.clone()),
            ));
        }

        let comp_constraint = AnyConstraint::new()
            .with("result_type", result_type)
            .with("has_else", has_else);

        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let result_type = constraint.get::<Type>("result_type").unwrap().clone();
        let has_else = constraint.get::<bool>("has_else").unwrap();

        let mut iter = asts.into_iter();

        let condition = iter.next().unwrap().into_expression().unwrap();

        // Then branch
        let mut branches = vec![iter.next().unwrap().into_branch().unwrap()];

        // Else branch
        if *has_else {
            branches.push(iter.next().unwrap().into_branch().unwrap());
        }

        Ok(IfElse {
            condition: Box::new(condition),
            branches,
            typ: result_type,
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
        ast.as_ifelse().is_some()
    }
}
