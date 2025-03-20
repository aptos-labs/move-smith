use crate::{
    generators::{AssignmentGenerator, SignatureGenerator},
    move_ast::{Assignment, MoveAST, Pattern, PatternKind, Variable},
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

fn get_initialized_vars_from_pattern(pattern: &Pattern) -> Vec<Id> {
    match &pattern.body {
        PatternKind::Variable(Variable::SingleVariable(sv)) => vec![sv.name.clone()],
        PatternKind::Variable(Variable::DotVariable(_)) => vec![],
        PatternKind::Positional(pats) => pats
            .iter()
            .flat_map(|f| {
                if let Some(p) = f {
                    get_initialized_vars_from_pattern(p)
                } else {
                    vec![]
                }
            })
            .collect(),
        PatternKind::Named(s) => s
            .iter()
            .flat_map(|(_, p)| get_initialized_vars_from_pattern(p))
            .collect(),
        PatternKind::Wildcard => vec![],
    }
}

/// We only need to monitor the entrance generator `ExprOfTypeGenerator`.
impl State<MoveAST> for InitMap {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, _generator: &GenLabel) {
        match new_ast {
            MoveAST::Signature(sig) => {
                for param in &sig.parameters {
                    self.init_map.insert(param.name.clone(), true);
                }
            },
            MoveAST::Assignment(Assignment::AssignPattern(pat, _)) => {
                let init_vars = get_initialized_vars_from_pattern(pat);
                for var in init_vars {
                    self.init_map.insert(var, true);
                }
            },
            MoveAST::EnumMatch(em) => {
                for arm in &em.arms {
                    for pat in &arm.patterns {
                        let vars = get_initialized_vars_from_pattern(pat);
                        for var in vars {
                            self.init_map.insert(var, true);
                        }
                    }
                }
            },
            _ => panic!("Unexpected Assignment, but got: {:?}", new_ast),
        }
    }
}
