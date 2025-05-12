use crate::{
    generators::BlockGenerator,
    move_ast::{Function, MoveAST, Script, Signature, TypeParameters, Visibility},
    states::{new_id_from_curr_scope_and_push_scope, IdKind, PartialInfo, Type, PARTIAL_SIGNATURE},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ScriptGenerator;

impl LabelledGenerator for ScriptGenerator {
    fn label() -> GenLabel {
        GenLabel::new("ScriptGenerator")
    }
}

impl Register<GeneratorEntry> for ScriptGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for ScriptGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (func_id, _, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Function);
        let signature = Signature {
            name: func_id,
            type_params: TypeParameters::default(),
            parameters: vec![],
            return_type: Type::Unit,
            abilities: vec![],
            is_func_value: false,
        };
        env.get_mut::<PartialInfo>()
            .unwrap()
            .store
            .get_mut(PARTIAL_SIGNATURE)
            .unwrap()
            .push(signature.clone().into());
        let block_constraint = AnyConstraint::new().with("is_function_body", true);
        let subtrees = vec![Subtree::new_generator_subtree(
            BlockGenerator::label(),
            block_constraint.clone(),
        )];
        Ok((subtrees, AnyConstraint::new().with("signature", signature)))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let body = asts.into_iter().next().unwrap().into_block().unwrap();
        let signature = constraint.get::<Signature>("signature").unwrap().clone();
        let func = Function {
            visibility: Visibility::Private,
            signature,
            body,
        };
        Ok(Script { main: func }.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_script().is_some()
    }
}
