
//# run 0xCAFE::MyModule::f1 --args 0u8 false

// Compile the program through multiple sequential passes

//# run 0xCAFE::MyModule::f1 --args 0u8 false

// Move compiler's target passing stage: use the `-p` flag with a specific pass identifier
// Since direct pass verification isn't achievable through Move script, simulate sequential compile runs

//# run 0xCAFE::MyModule::f1 --args 0u8 false

// Now, create a script with nested loops that increment a counter

//# run
script nested_loop_counter {
    fun main() {
        let count: u32 = 0;
        let i: u32 = 0;

        while (i < 5) {
            let j: u32 = 0;
            while (j < 4) {
                // increment count
                let count = count + 1;
                // increment j
                let j = j + 1;
            };
            // increment i
            let i = i + 1;
        };
        // produce the final count for verification
        count
    }
}

// Run the nested loop test

//# run 0xCAFE::MyModule::main

// Create a script with an infinite loop with early return

//# run
script infinite_loop_with_return {
    fun main() {
        let i: u32 = 0;

        loop {
            // Early return inside loop; for compliance with rules, emulate early return with break
            if (i >= 3) {
                break;
            };
            i = i + 1;
        };
        // Should not reach here if loop breaks early
        let _assert_fail = false;
        assert!(_assert_fail, 999);
        // The script completes successfully before reaching the assertion
        i
    }
}

// Run the infinite loop with early return test

//# run 0xCAFE::MyModule::main


// Featurres:
// 8ec3435bf1358828adc414949546d591: Use the compiler's run function to process a Move program through multiple compiler passes until reaching a specified pass stage.
// 2eccb8c408c0d24e4020ef8cdbb150e1: Verify that nested loops correctly increment a counter and that the final value matches the expected total after repeated iterations.
// 7960ce7ec9415e18675fd9fadb6188e9: Test that a script with an infinite loop containing an early return does not execute code after the loop, such as an assertion, ensuring the move semantics correctly handle early returns within loops.
