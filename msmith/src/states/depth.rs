use crate::{generators::ExprOfTypeGenerator, move_ast::MoveAST};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};
use log::trace;

#[derive(Debug, Default)]
pub struct DepthRing {
    /// The name of the depth, used for logging
    name: String,

    /// The list of max depths candidates
    max_depths: Vec<usize>,
    /// The current index of the max depth
    max_depth_idx: usize,

    /// The current depth of the generation
    curr_depth: usize,

    /// If a manual max depth is set
    manual_set: bool,
    /// The history of manual depths, for easy restoration
    manual_depth_history: Vec<usize>,
}

impl DepthRing {
    pub fn new(name: String) -> Self {
        Self {
            name,
            max_depths: vec![],
            max_depth_idx: 0,
            curr_depth: 0,
            manual_set: false,
            manual_depth_history: vec![],
        }
    }

    /// Initialize a new DepthRing with `num_depths` random depths
    pub fn initialize(&mut self, depths: Vec<usize>) {
        self.max_depths = depths;
    }

    /// Get the current max depth limit
    /// If a manual depth is set, return the last manual depth
    /// If not, return the current round-robin depth
    #[inline]
    fn get_curr_max_depth_limit(&self) -> usize {
        if self.manual_set {
            self.manual_depth_history.last().copied().unwrap()
        } else {
            self.max_depths[self.max_depth_idx]
        }
    }

    /// Move to the next depth limit in the round-robin fashion
    fn move_to_next_depth_limit(&mut self) {
        self.max_depth_idx = (self.max_depth_idx + 1) % self.max_depths.len();
        trace!(
            "using new {} depth: {}",
            self.name,
            self.get_curr_max_depth_limit()
        );
    }

    /// Check if the current generation has reached the depth
    pub fn reached_depth_limit(&self) -> bool {
        self.curr_depth() >= self.get_curr_max_depth_limit()
    }

    /// Check if the current generation will reach the depth with `inc` more steps
    pub fn will_reached_depth_limit(&self, inc: usize) -> bool {
        self.curr_depth() + inc >= self.get_curr_max_depth_limit()
    }

    /// Return the current depth
    #[inline]
    pub fn curr_depth(&self) -> usize {
        self.curr_depth
    }

    /// Increase the current depth by 1
    pub fn increase_depth(&mut self) {
        self.curr_depth += 1;
        trace!("Increment {} depth to: {}", self.name, self.curr_depth());
    }

    /// Decrease the current depth by 1
    /// If we reach the end of some generation step (depth becomes 0), we can use the next depth
    pub fn decrease_depth(&mut self) {
        self.curr_depth -= 1;
        trace!("Decrement {} depth to: {}", self.name, self.curr_depth());
        // We reach the end of some generation step, we can use the next depth
        if self.curr_depth() == 0 && !self.manual_set {
            self.move_to_next_depth_limit();
        }
    }

    /// Set a temporary maximum depth.
    pub fn set_max_depth(&mut self, max_depth: usize) {
        self.manual_depth_history.push(max_depth);
        self.manual_set = true;
    }

    /// Restore the maximum depth to the previous value.
    pub fn reset_max_depth(&mut self) {
        self.manual_depth_history.pop();
        self.manual_set = !self.manual_depth_history.is_empty();
    }
}

/// Keeps track of the current depth of the expression tree being generated
/// and the maximum depth allowed.
#[derive(Debug, Default)]
pub struct Depth {
    pub expr_depth: DepthRing,
}

impl LabelledState for Depth {
    fn label() -> StateLabel {
        StateLabel::new("ExpressionDepth")
    }
}

impl Register<StateEntry> for Depth {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![ExprOfTypeGenerator::label()],
        }
    }
}

/// We only need to monitor the entrance generator `ExprOfTypeGenerator`.
impl State<MoveAST> for Depth {
    fn update_pre(&mut self, _u: &mut Unstructured, generator: &GenLabel) {
        // Skip sub-generators to avoid double-counting
        if *generator != ExprOfTypeGenerator::label() {
            return;
        }

        self.expr_depth.increase_depth();
        trace!(
            "Increasing expression depth to {} for {}, max_depth is {}",
            self.expr_depth.curr_depth(),
            generator,
            self.expr_depth.get_curr_max_depth_limit()
        );
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, generator: &GenLabel) {
        // Skip sub-generators to avoid double-counting
        if *generator != ExprOfTypeGenerator::label() {
            return;
        }
        self.expr_depth.decrease_depth();
        trace!(
            "Decreasing expression depth to {} for {}",
            self.expr_depth.curr_depth(),
            generator
        );
    }
}
