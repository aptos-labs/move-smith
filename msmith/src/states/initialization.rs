use crate::{
    generators::{AssignmentGenerator, SignatureGenerator},
    move_ast::{Expression, MoveAST, Variable},
    states::Id,
};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};
use std::collections::BTreeMap;

#[derive(Debug, Default)]
pub struct InitMap {
    pub init_map: BTreeMap<Id, bool>,
}

impl InitMap {
    pub fn is_var_initialized(&self, id: &Id) -> bool {
        self.init_map.get(id).cloned().unwrap_or(false)
    }

    pub fn set_var_initialized(&mut self, id: Id) {
        self.init_map.insert(id, true);
    }
}

impl LabelledState for InitMap {
    fn label() -> StateLabel {
        StateLabel::new("InitMap")
    }
}

impl Register<StateEntry> for InitMap {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![AssignmentGenerator::label(), SignatureGenerator::label()],
        }
    }
}

/// We only need to monitor the entrance generator `ExprOfTypeGenerator`.
impl State<MoveAST> for InitMap {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, _generator: &GenLabel) {
        use Expression as E;
        match new_ast {
            MoveAST::Signature(sig) => {
                for param in &sig.parameters {
                    self.init_map.insert(param.name.clone(), true);
                }
            },
            MoveAST::Assignment(assign) => match assign.lhs.as_ref() {
                E::Variable(Variable::SingleVariable(v)) => {
                    self.init_map.insert(v.name.clone(), true);
                },
                E::Tuple(t) => {
                    for elem in &t.expressions {
                        match elem {
                            E::Variable(Variable::SingleVariable(v)) => {
                                self.init_map.insert(v.name.clone(), true);
                            },
                            _ => unimplemented!(),
                        }
                    }
                },
                E::StructDestructure(sd) => {
                    sd.new_vars.iter().for_each(|v| {
                        if let Some(v) = v {
                            self.init_map.insert(v.name.clone(), true);
                        }
                    });
                },
                _ => unimplemented!(),
            },
            _ => panic!("Unexpected Assignment, but got: {:?}", new_ast),
        }
    }
}
