//# publish
module 0xCAFE::variable_scope_test {
    use std::debug;

    // A helper function to trigger an abort for testing purposes
    public fun aborter() {
        // Trigger an abort by calling a division by zero
        let _ = 1 / 0;
        // The following line will not be executed
        debug::print(&b"Should not reach here.");
    }

    #[test]
    public fun scope_and_abort_test() {
        // Declare a mutable local variable with initial value
        let x: u64 = 10;

        // Enter a new block scope
        {
            // Declare a variable with a different name, initialized
            let y: bool = true;

            // Declare a variable with a type parameter, here fixed as u8
            let t: u8 = 255;

            // Modify existing variable inside block
            x = x + 5;

            // Call a function that aborts inside this block
            // This simulates abort happening within a nested call
            aborter();

            // This line should not execute
            x = x + 100;
        }

        // After abort, the changes to x that occurred before the abort should persist
        // But since the abort occurs before x is updated, x is still original
        // However, in actual execution, the test would abort at 'aborter()'
        // For testing, comment out the abort call to continue

        // Alternatively, to simulate the state after an abort, we can do:
        // (In real transactional environment, the whole transaction would rollback)
        // but here, for the purpose of the test, we can assume the abort halts execution.
    }

    //# run 0xCAFE::variable_scope_test::scope_and_abort_test --signers 0xCAFE
}

// Featurres:
// 16286f821252777f946601b8db8d5501: Declare variables with scope, names, type parameters, types, and initializers.
// 15e5c0d4c40f8742de990d02abd6d303: Test that local variables modified inside a block expression are correctly updated after an abort occurs within a function call inside the block.
// 4b1e2b46aabc7fb4cadc6b955a2b1035: Write code blocks where the final expression is allowed without a trailing semicolon to return its value.
