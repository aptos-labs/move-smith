use crate::{
    generators::{BlockGenerator, ExprOfTypeGenerator},
    move_ast::{MatchArm, MoveAST, Pattern},
    states::{pop_scope, push_scope, EnumVariantType, Scope, Type},
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct MatchArmGenerator;

impl LabelledGenerator for MatchArmGenerator {
    fn label() -> GenLabel {
        GenLabel::new("MatchArmGenerator")
    }
}

impl Register<GeneratorEntry> for MatchArmGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for MatchArmGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<EnumVariantType>("variant_type")
            && constraint.check_exist_and_type::<Pattern>("pattern")
            && constraint.check_exist_and_type::<Type>("type")
            && constraint.check_exist_and_type::<Scope>("scope")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let typ = constraint.get::<Type>("type").unwrap();
        let scope = constraint.get::<Scope>("scope").unwrap();
        push_scope(env, scope.clone());

        let mut subtrees = vec![];

        let use_block_as_body = bool::arbitrary(u)?;
        if use_block_as_body {
            // TODO: add config number for number seq in arm
            subtrees.push(Subtree::new_generator_subtree(
                BlockGenerator::label(),
                AnyConstraint::new()
                    .with("type", typ.clone())
                    .with("num_sequences", 2)
                    .with("is_function_body", false),
            ));
        } else {
            subtrees.push(Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                AnyConstraint::new().with("type", typ.clone()),
            ))
        }
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
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        pop_scope(env);
        let variant_type = constraint
            .get::<EnumVariantType>("variant_type")
            .unwrap()
            .clone();
        let pattern = constraint.get::<Pattern>("pattern").unwrap().clone();
        let typ = constraint.get::<Type>("type").unwrap().clone();
        let body = asts.into_iter().next().unwrap();
        Ok(MatchArm {
            variant_type,
            pattern,
            condition: None,
            body: Box::new(body),
            typ,
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        let use_block_as_body = comp_constraint.get::<bool>("use_block_as_body").unwrap();
        match ast.as_matcharm() {
            Some(arm) => {
                if *use_block_as_body {
                    arm.body.as_block().is_some()
                } else {
                    arm.body.as_expression().is_some()
                }
            },
            None => false,
        }
    }
}
