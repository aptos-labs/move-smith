use crate::{
    move_ast::{MoveAST, Signature, TypeParameters},
    CurrScope, IdKind, IdPool,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct SignatureGenerator;

impl Labelled for SignatureGenerator {
    fn label() -> Label {
        GenLabel::new_func_body_level("SignatureGenerator").into()
    }
}

impl Register<GeneratorEntry> for SignatureGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
            forward: false,
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for SignatureGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        warn!("check_constraint not implemented for SignatureGenerator");
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        warn!("subtrees not implemented for SignatureGenerator");
        Ok((vec![], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let curr_scope = env.get::<CurrScope>().unwrap().get();
        let (name, _scope) = env
            .get_mut::<IdPool>()
            .unwrap()
            .next_id(IdKind::Function, &curr_scope);
        Ok(Signature {
            name,
            type_params: TypeParameters::default(),
            parameters: vec![],
            return_type: None,
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_signature().is_some()
    }
}
