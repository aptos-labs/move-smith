
//# publish
module 0xBADD::TestModule {
    use std::vector;

    const CONST_VALUE: u8 = 42;

    struct DataHolder has store, key {
        flag: bool,
        count: u64,
    }

    // Public function to invoke module's internal and external features
    public fun entry_point() {
        // Call external module functions (these are scripts, so calling internally)
        module_function_script();

        // Call internal function (allowed)
        internal_helper();

        // Attempt to call internal function from outside (should be disallowed, comment out to prevent compile error)
        // internal_helper(); // Should not compile if attempted from outside
    }

    // Internal function not accessible outside
    fun internal_helper() {
        // Internal logic
        let _ = CONST_VALUE;
    }

    // Function to test variable shadowing and scope
    public fun test_variable_scopes(): (u64, bool, u64, u64) {
        let x = 10;
        let result_x = x;

        let outside_var = 999;

        // Outer while loop with local variable shadowing
        while (result_x < 20) {
            let result_x = result_x + 1; // shadowed variable
            outside_var = outside_var + result_x;
        };

        // After loop, outside_var should be updated, result_x is shadowed inside loop
        let y = false;
        if (result_x >= 20) {
            y = true;
        };

        (result_x, y, outside_var, CONST_VALUE as u64)
    }

    // Function to test direct referencing of module constant
    public fun use_constant_directly(): u8 {
        // Reference the constant directly without qualification
        let c = CONST_VALUE;
        c
    }
}

// Script to invoke module entry point

//# run 0xBADD::TestModule::entry_point


//# run 0xBADD::TestModule::test_variable_scopes


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 78520ca50c9e7a8aa1f699cba2de2832: Reference local or module names directly as expressions.
