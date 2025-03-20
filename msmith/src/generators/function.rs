use crate::{
    move_ast::{Function, MoveAST},
    states::{new_id_from_curr_scope_and_push_scope, pop_scope, IdKind, Type},
    BlockGenerator, SignatureGenerator,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct FunctionGenerator;

impl LabelledGenerator for FunctionGenerator {
    fn label() -> GenLabel {
        GenLabel::new_module_member_level("FunctionGenerator")
    }
}

impl Register<GeneratorEntry> for FunctionGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for FunctionGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<Type>("type")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (name, scope, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Function);
        let signature_constraint = constraint.clone().with("name", name).with("scope", scope);
        let mut subtrees = vec![];
        subtrees.push(Subtree::new_generator_subtree(
            SignatureGenerator::label(),
            signature_constraint.clone(),
        ));
        let block_constraint = AnyConstraint::new().with("is_function_body", true);
        subtrees.push(Subtree::new_generator_subtree(
            BlockGenerator::label(),
            block_constraint.clone(),
        ));
        let comp_constraint = AnyConstraint::new()
            .with_constraint(&signature_constraint)
            .with_constraint(constraint);
        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        pop_scope(env);
        let signature = asts.remove(0).into_signature().unwrap();
        let body = asts.remove(0).into_block().unwrap();
        Ok(Function { signature, body }.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_function().is_some()
    }
}
