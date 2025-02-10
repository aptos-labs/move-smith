use crate::{
    generators::SignatureGenerator,
    move_ast::{MoveAST, Signature, TypeParameters},
    states::{get_config, Id, TypePool, TypeSelectorBuilder},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct TupleSignatureGenerator;

impl LabelledGenerator for TupleSignatureGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("TupleSignatureGenerator").into()
    }
}

impl Register<GeneratorEntry> for TupleSignatureGenerator {
    fn register(&self) -> GeneratorEntry {
        let mut entry = GeneratorEntry::new::<Self>();
        entry.add_parent::<SignatureGenerator>();
        entry.skip_parent = true;
        entry
    }
}

impl Generator<MoveAST, AnyConstraint> for TupleSignatureGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let type_selector = TypeSelectorBuilder::all_no(get_config(env))
            .tuple(1)
            .build();
        let ret_type = env
            .get_fail::<TypePool>()
            .random_type(u, vec![type_selector])?;

        let subtree = Subtree::new_single_candidate(
            Signature {
                name: constraint.get::<Id>("name").unwrap().clone(),
                type_params: TypeParameters::default(),
                parameters: vec![],
                return_type: Some(ret_type),
            }
            .into(),
        );
        return Ok((vec![subtree], AnyConstraint::new()));
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
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_signature().is_some()
    }
}
