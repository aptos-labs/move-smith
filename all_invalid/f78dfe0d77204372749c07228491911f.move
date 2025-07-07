
//# run 0xCAFE::MoveCompilerTest::process_through_passes

//# publish
module 0xCAFE::MoveCompilerTest {
    use std::string;
    use std::vector;

    // Enumeration to simulate different compiler passes
    enum PassStage {
        NotStarted,
        SyntaxCheck,
        TypeCheck,
        Optimization,
        Emission,
        Done
    }

    // State to hold current stage in compilation
    struct CompilerState has key {
        current_stage: PassStage
    }

    // Initialize with NotStarted state
    public fun init_state(): CompilerState {
        let state = CompilerState { current_stage: PassStage::NotStarted };
        state
    }

    // Function to process through compiler passes
    public fun process_pass(state_ref: &mut CompilerState): bool {
        switch (state_ref.current_stage) {
            PassStage::NotStarted => {
                state_ref.current_stage = PassStage::SyntaxCheck;
                false
            },
            PassStage::SyntaxCheck => {
                state_ref.current_stage = PassStage::TypeCheck;
                false
            },
            PassStage::TypeCheck => {
                state_ref.current_stage = PassStage::Optimization;
                false
            },
            PassStage::Optimization => {
                state_ref.current_stage = PassStage::Emission;
                false
            },
            PassStage::Emission => {
                state_ref.current_stage = PassStage::Done;
                false
            },
            PassStage::Done => true
        }
    }
}


//# run 0xCAFE::MoveCompilerTest::test_pass_progression --signers 0xCAFE


//# publish
module 0xCAFE::NestedLoops {
    // Test nested loops incrementing a counter
    public fun nested_loop_test(): u64 {
        let count: u64 = 0;

        let _ = {
            let outer: u64 = 0;
            while (outer < 3) {
                let inner: u64 = 0;
                while (inner < 4) {
                    outer = outer + 1;
                    inner = inner + 1;
                };
            };
            outer
        };
        count
    }
}


//# run 0xCAFE::NestedLoops::nested_loop_test


//# publish
module 0xCAFE::EarlyReturnInLoop {
    // Script with early return inside an infinite loop to test control flow
    public fun early_return_loop(): bool {
        let count: u64 = 0;
        loop {
            count = count + 1;
            if (count == 5) {
                break;
            };
        };
        if (count != 5) {
            // Should not reach here
            false
        } else {
            true
        }
    }
}


//# run 0xCAFE::EarlyReturnInLoop::early_return_loop


// Featurres:
// 8ec3435bf1358828adc414949546d591: Use the compiler's run function to process a Move program through multiple compiler passes until reaching a specified pass stage.
// 2eccb8c408c0d24e4020ef8cdbb150e1: Verify that nested loops correctly increment a counter and that the final value matches the expected total after repeated iterations.
// 7960ce7ec9415e18675fd9fadb6188e9: Test that a script with an infinite loop containing an early return does not execute code after the loop, such as an assertion, ensuring the move semantics correctly handle early returns within loops.
