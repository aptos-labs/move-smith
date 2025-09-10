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
pub const SPEC_SIGNATURE: &str = "SpecSignature";

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

    fn update_post(&mut self, u: &mut Unstructured, new_ast: &MoveAST, _generator: &GenLabel) {
        if let MoveAST::Signature(s) = new_ast {
            trace!("Adding partial signature to store: {new_ast:?}");
            self.store
                .insert(PARTIAL_SIGNATURE.to_string(), vec![new_ast.clone()]);

            // Randomly decide whether to generate a spec for this function
            // Only generate specs for normal functions (not producers or runners)
            if s.name.is_normal_func() {
                let should_generate = u.ratio(1, 3).unwrap_or(false);
                if should_generate {
                    trace!("Adding signature {} to spec generation queue", s.name);
                    self.store
                        .entry(SPEC_SIGNATURE.to_string())
                        .or_insert_with(Vec::new)
                        .push(new_ast.clone());
                }
            };
        }
        if let MoveAST::Callable(_c) = new_ast {
            trace!("Adding partial callable to store: {new_ast:?}");
            self.store
                .insert(PARTIAL_CALLABLE.to_string(), vec![new_ast.clone()]);
        }
    }
}
