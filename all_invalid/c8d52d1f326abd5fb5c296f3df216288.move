
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
            }; // semicolon added after block
            PassStage::SyntaxCheck => {
                state_ref.current_stage = PassStage::TypeCheck;
                false
            };
            PassStage::TypeCheck => {
                state_ref.current_stage = PassStage::Optimization;
                false
            };
            PassStage::Optimization => {
                state_ref.current_stage = PassStage::Emission;
                false
            };
            PassStage::Emission => {
                state_ref.current_stage = PassStage::Done;
                false
            };
            PassStage::Done => {
                true
            }
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
            let outer: u64 = 0; // make outer mutable
            while (outer < 3) {
                let inner: u64 = 0; // make inner mutable
                while (inner < 4) {
                    outer = outer + 1;
                    inner = inner + 1;
                }; // semicolon added after inner while
            }; // semicolon added after outer while
            outer
        };
        count
    }
}



//# run 0xCAFE::NestedLoops::nested_loop_test



//# publish
module 0xCAFE::EarlyReturnInLoop {
    // Script with early return inside a loop to test control flow
    public fun early_return_loop(): bool {
        let count: u64 = 0; // make count mutable
        loop {
            count = count + 1;
            if (count == 5) {
                break;
            }; // semicolon added after if
        }; // semicolon added after loop
        if (count != 5) {
            // Should not reach here
            false
        } else {
            true
        }
    }
}
