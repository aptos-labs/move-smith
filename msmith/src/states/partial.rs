use crate::{
    generators::{CallableGenerator, SignatureGenerator},
    move_ast::MoveAST,
};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};
use log::trace;
use std::collections::BTreeMap;

pub const PARTIAL_SIGNATURE: &str = "PartialSignature";
pub const PARTIAL_CALLABLE: &str = "PartialCallable";

#[derive(Debug, Default)]
pub struct PartialInfo {
    pub store: BTreeMap<String, Vec<MoveAST>>,
}

impl LabelledState for PartialInfo {
    fn label() -> StateLabel {
        StateLabel::new("PartialInfo")
    }
}

impl Register<StateEntry> for PartialInfo {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![SignatureGenerator::label(), CallableGenerator::label()],
        }
    }
}

impl State<MoveAST> for PartialInfo {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, _generator: &GenLabel) {
        if let MoveAST::Signature(_s) = new_ast {
            trace!("Adding partial signature to store: {new_ast:?}");
            self.store
                .insert(PARTIAL_SIGNATURE.to_string(), vec![new_ast.clone()]);
        }
        if let MoveAST::Callable(_c) = new_ast {
            trace!("Adding partial callable to store: {new_ast:?}");
            self.store
                .insert(PARTIAL_CALLABLE.to_string(), vec![new_ast.clone()]);
        }
    }
}
