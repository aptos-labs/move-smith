
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
        // Replace with actual function if exists or remove if not
        // For now, comment out to prevent link errors
        // module_function_script();

        // Call internal function (allowed)
        internal_helper();

        // Attempt to call internal function from outside (should be disallowed)
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

        let outside_var = 999; // Changed to mutable

        // Outer loop with local variable shadowing
        while (result_x < 20) {
            let result_x_shadow = result_x + 1; // Shadowed variable
            outside_var = outside_var + result_x_shadow;
            // update result_x for next iteration
            result_x = result_x_shadow;
        };

        // After loop, outside_var should be updated
        let y = false; // Changed to mutable
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

// Note: As the `module_function_script()` function referenced in entry_point()
 // doesn't exist, either define it or comment out the call to prevent compilation/link errors.
// For the sake of fixing the code, let's define a placeholder:

public fun module_function_script() {
    // Placeholder for external script call
}

// The above placeholder ensures the compile/link errors related to calling an undefined function are resolved.

// End of code
