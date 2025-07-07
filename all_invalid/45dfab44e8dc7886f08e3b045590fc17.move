
//# publish
module 0xBAD1C0DE::TestModule {
    // Use only std for simplicity.
    use std::signer;
    use std::vector;

    // Private internal function - should not be accessible from outside.
    fun internal_private_function() acquires /* no data */ {
        // do nothing
    }

    // Public function that calls an internal one, used in scripts.
    public fun call_internal() {
        internal_private_function();
    }

    // Function to test variable shadowing inside loop.
    public fun shadow_variable_test(x: u8): u8 acquires /* no data */ {
        let y = x;
        let y_shadow = y + 1; // shadowing outer y is invalid, but for test, let's simulate shadowing.
        // But in Move, no variable shadowing, so we'll simulate the idea by reusing variable names in nested scopes.
        let result = {
            let y = y_shadow; // shadow y.
            while (y < 10) {
                let y = y + 1; // inner y shadow.
                y // last value in inner loop
            }
            y // outer y
        };
        result
    }

    // Function with for loop and variable assignment inside.
    public fun assign_in_for_loop() {
        let sum: u64 = 0;
        let vec = vector::immutable([1u8, 2, 3, 4]);
        let len = vector::length(&vec);
        for (i in 0..len) {
            let val = *vector::borrow(&vec, i);
            sum = sum + (val as u64);
        }
        sum
    }

    // Function to test variable assignment inside while loop.
    public fun assign_in_while() {
        let x: u8 = 0;
        while (x < 5) {
            x = x + 1;
        }
        x
    }

    // Function attempting to call an internal function from outside - should fail permissionally.
    // We add this as an internal function call from a script.
    public fun call_private() {
        
//# run 0xBAD1C0DE::TestModule::try_call_private
        // placeholder, actual call will be in script.
    }

    // Internal function to test dependency linkage - should not be callable from outside.
    fun internal_dependency() {}

    // Utility function to test sequence of access specifiers (simulate)
    // Not native to Move, just a conceptual test.
    public fun test_access_sequence() {
        // No actual syntax enforcement here.
        // Just call functions with multiple access specifiers conceptually.
        // e.g., public, private, internal, etc.
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
        // But since this is a test, we comment out or note that.
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

//# run 0xBAD1C0DE::TestModule::main


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c1d1e13893b59b8cc7f8b47cbab7747c: Specify immediate neighbors and used addresses for modules and scripts for dependency analysis.
// a440e58d891781b6fb14de77ca4e6818: Handle multiple access specifiers in a sequence possibly separated by commas, including a trailing comma.
