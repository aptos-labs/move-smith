use crate::{generators::ExprOfTypeGenerator, move_ast::MoveAST};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};
use log::trace;

/// Keeps track of the current depth of the expression tree being generated
/// and the maximum depth allowed.
#[derive(Debug, Default)]
pub struct ExpressionDepth {
    pub curr_depth: usize,
    pub max_depth: usize,
}

impl ExpressionDepth {
    pub fn curr_depth(&self) -> usize {
        self.curr_depth
    }

    pub fn reached_max_depth(&self) -> bool {
        self.curr_depth >= self.max_depth
    }

    pub fn almost_reached_max_expr_depth(&self, threshold: usize) -> bool {
        self.curr_depth + threshold >= self.max_depth
    }
}

impl LabelledState for ExpressionDepth {
    fn label() -> StateLabel {
        StateLabel::new("ExpressionDepth")
    }
}

impl Register<StateEntry> for ExpressionDepth {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![ExprOfTypeGenerator::label()],
        }
    }
}

/// We only need to monitor the entrance generator `ExprOfTypeGenerator`.
impl State<MoveAST> for ExpressionDepth {
    fn update_pre(&mut self, _u: &mut Unstructured, generator: &GenLabel) {
        // Skip sub-generators to avoid double-counting
        if *generator != ExprOfTypeGenerator::label() {
            return;
        }

        self.curr_depth += 1;
        trace!(
            "Increasing expression depth to {} for {}",
            self.curr_depth,
            generator
        );
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, generator: &GenLabel) {
        // Skip sub-generators to avoid double-counting
        if *generator != ExprOfTypeGenerator::label() {
            return;
        }
        self.curr_depth -= 1;
        trace!(
            "Decreasing expression depth to {} for {}",
            self.curr_depth,
            generator
        );
    }
}
