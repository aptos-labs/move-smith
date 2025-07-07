
//# publish
module 0xCAFE::LoopTestModule {
    // Structure to hold state for loop tests
    struct LoopState has copy, drop {
        counter: u64,
        threshold: u64,
    }

    // Function to initialize LoopState
    public fun initialize_state(threshold: u64): LoopState {
        LoopState { counter: 0, threshold }
    }

    // Function to run while loop, increment counter until threshold
    public fun run_loop(state: &mut LoopState) {
        while (state.counter < state.threshold) {
            state.counter = state.counter + 1;
        }
    }

    // Getter for counter to verify the result
    public fun get_counter(state: &LoopState): u64 {
        state.counter
    }
}


//# run
script {
    fun main() {
        let threshold = 10u64;
        let state = 0xCAFE::LoopTestModule::initialize_state(threshold);
        0xCAFE::LoopTestModule::run_loop(&mut state);
        let final_count = 0xCAFE::LoopTestModule::get_counter(&state);
        // The final_count should be equal to threshold (10)
        assert(final_count == threshold, 0);
    }
}

// Featurres:
// 5f91446db6e4b5867a7ed46720a31d65: Test that a while loop correctly increments a variable until the specified condition is met and that the final assertion verifies the loop's expected outcome.
// bba044143266d7d877a176758bba1c70: Define per-directory named address mappings and propagate those named addresses into parsed Move modules and scripts.
// abd25da38d9545b2ed9af23a951107c4: Allow defining specific behaviors for how list parsing continues or terminates by passing in closure functions.
