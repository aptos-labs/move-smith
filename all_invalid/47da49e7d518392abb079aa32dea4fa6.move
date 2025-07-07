
//# publish
module 0xBAD1C0DE::TestModule {
    // Use only std for simplicity.
    use std::signer;
    use std::vector;

    // Internal function - only accessible within this module.
    fun internal_private_function() {
        // do nothing
    }

    // Public function that calls an internal one, used in scripts.
    public fun call_internal() {
        internal_private_function();
    }

    // Function to test variable shadowing inside loop.
    public fun shadow_variable_test(x: u8): u8 {
        let y = x;
        // In Move, variable shadowing is not allowed as in traditional sense,
        // but we can simulate nested scopes with code blocks.
        let result = {
            let y_inner = y + 1; // simulate shadowing y
            let y = y_inner; // outer y shadowed
            while (y < 10) {
                let y_inner = y + 1; // inner y shadow
                y = y_inner; // update y for next iteration
            }
            y // return outer y
        };
        result
    }

    // Function with for loop and variable assignment inside.
    public fun assign_in_for_loop(): u64 {
        let sum: u64 = 0;
        let vec = vector::immutable([1u8, 2, 3, 4]);
        let len = vector::length(&vec);
        let i = 0;
        while (i < len) {
            let val = *vector::borrow(&vec, i);
            sum = sum + (val as u64);
            i = i + 1;
        }
        sum
    }

    // Function to test variable assignment inside while loop.
    public fun assign_in_while(): u8 {
        let x: u8 = 0;
        while (x < 5) {
            x = x + 1;
        };
        x
    }

    // Function attempting to call an internal function from outside - should fail permissionally.
    // We add this as an internal function call from a script.
    public fun call_private() {
        internal_private_function();
    }

    // Internal function to test dependency linkage - should not be callable from outside.
    fun internal_dependency() {}

    // Utility function to test sequence of access specifiers (simulate)
    // Not native to Move, just a conceptual test.
    public fun test_access_sequence() {
        // No actual syntax enforcement here.
        // Just call functions with multiple access specifiers conceptually.
        // For demonstration, calling internal functions.
        internal_dependency();
        call_internal();
    }
}

// Entry point script to invoke various module functions and test behaviors.
 

//# run
script {
    fun main() {
        // Call function that creates variable shadowing.
        let shadow_result = 0xBAD1C0DE::TestModule::shadow_variable_test(3);
        // Call assign_in_for_loop.
        let sum_for = 0xBAD1C0DE::TestModule::assign_in_for_loop();
        // Call assign_in_while.
        let last_value = 0xBAD1C0DE::TestModule::assign_in_while();

        // Attempt to call internal function from outside - should be compile error.
        // 0xBAD1C0DE::TestModule::internal_private_function();

        // Call function that calls internal/private.
        0xBAD1C0DE::TestModule::call_internal();

        // Test sequence of access specifiers (conceptual)
        0xBAD1C0DE::TestModule::test_access_sequence();

        // Attempt to call internal_dependency directly - should be disallowed outside module.
        // This line should be commented out to avoid compile error:
        // 0xBAD1C0DE::TestModule::internal_dependency();

        // Usage of shadow variables, assignments, loops completes here.
        // No output assertions; just execution.
        ()
    }
}


//# run 0xBAD1C0DE::main
