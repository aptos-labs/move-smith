
//# run
script {
    // This script processes a simple program through multiple compiler passes to check halting at a specific stage.
    // The program defines a basic function with an if-else construct.
    // The compilation should halt at the "Validation" stage, and the code should still be valid.
    // We do not assign or run any functions, just compile.

    // The compiler could be invoked with a command like:
    // move compile --target-compiler-stage=Validation --program "..."
    // But since we are simulating, this is a placeholder for the test infrastructure to invoke.
}


//# run
script {
    // Next, define a module with nested loops counting total iterations.
    // The goal is to verify that nested loop execution results in the correct total counter value.
    // This code will be compiled and executed.


//# publish
module 0xCAFE::NestedLoopsTest {
    use std::vector;

    public fun count_nested_iterations(): u64 {
        let total: u64 = 0;
        let outer: u64 = 3;
        let inner: u64 = 2;
        let i = 0;
        while (i < outer) {
            let j = 0;
            while (j < inner) {
                total = total + 1;
                j = j + 1;
            };
            i = i + 1;
        };
        total
    }
}


//# run 0xCAFE::NestedLoopsTest::count_nested_iterations



//# run
script {
    // Now, create a script with an infinite loop containing an early return inside.
    // After the early return, code should not execute; if assertions are correct, the last assertion should not run.

    // Implementation:
    // - An infinite loop
    // - Inside, a condition triggers a return statement
    // - After the loop, an assertion checks a value that should never be reached if return works properly

    // This simulates early exit semantics.
}


//# run
script {
    fun early_exit_test(): bool {
        let x = 0u8;
        loop {
            if (x == 5) {
                break; // Exit loop if x == 5
            };
            if (x == 2) {
                // Enforce early return when x == 2
                return true;
            };
            x = x + 1;
        };
        // Code beyond loop should only execute if no early return occurs
        false
    }
}


//# run 0xCAFE::early_exit_test::early_exit_test
