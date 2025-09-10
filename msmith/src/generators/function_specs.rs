use crate::{
    generators::FunctionSpecGenerator,
    move_ast::{FunctionSpecs, MoveAST},
    states::{PartialInfo, SPEC_SIGNATURE},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct FunctionSpecsGenerator;

impl LabelledGenerator for FunctionSpecsGenerator {
    fn label() -> GenLabel {
        GenLabel::new_top_level("FunctionSpecsGenerator")
    }
}

impl Register<GeneratorEntry> for FunctionSpecsGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for FunctionSpecsGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let partial_info = env.get_mut::<PartialInfo>().unwrap();
        let mut empty_sigs = vec![];
        let spec_signatures = partial_info
            .store
            .get_mut(SPEC_SIGNATURE)
            .unwrap_or(&mut empty_sigs);

        let mut subtrees = vec![];

        while !spec_signatures.is_empty() {
            let signature = spec_signatures.remove(0);
            if let MoveAST::Signature(sig) = signature {
                let constraint = AnyConstraint::new().with("target_function", sig.clone());
                subtrees.push(Subtree::new_generator_subtree(
                    FunctionSpecGenerator::label(),
                    constraint,
                ));
            }
        }

        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let mut function_specs = vec![];

        for ast in asts {
            if let Some(spec_block) = ast.as_specblock() {
                function_specs.push(spec_block.clone());
            }
        }

        Ok(FunctionSpecs(function_specs).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_functionspecs().is_some()
    }
}
