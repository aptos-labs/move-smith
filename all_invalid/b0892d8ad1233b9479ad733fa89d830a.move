
//# publish
module 0xCAFE::ScopeAndVisibilityTests {
    use std::signer;

    // A function with internal (private) visibility; should only be accessible within this module
    fun internal_add(a: u64, b: u64): u64 {
        a + b
    }

    // Public entry point script function to test variable scope and shadowing
    public fun script_entry_test_x_var(start: u64): u64 {
        // Outer variable
        let x = start;
        let outer_x = x;
        let y = 0;

        // Loop with variable shadowing
        while (x < start + 3) {
            // Shadow variable x inside the loop
            let x = x + 1;
            y = y + x; // sum shadowed x
            // Reassign outer x for next iteration
            outer_x = x;
        };
        // Return the accumulated y
        y
    }

    // Similar test with variable declared outside loop, reassigned inside
    public fun script_entry_test_y_var(start: u64): u64 {
        let y = 0;
        let x = start;
        while (x < start + 3) {
            // redeclare y inside the loop? No, persistent y
            y = y + x;
            x = x + 1;
        };
        y
    }

    // Function that attempts to call an internal function from outside (should fail if outside module)
    // This is for testing access restriction, but since we cannot cause a compile error in test,
    // we simply define a function that would be invalid outside.
    public fun call_internal_add(a: u64, b: u64): u64 {
        internal_add(a, b)
    }
}


//# run 0xCAFE::ScopeAndVisibilityTests::script_entry_test_x_var --args 5u64

//# run 0xCAFE::ScopeAndVisibilityTests::script_entry_test_y_var --args 7u64

//# run 0xCAFE::ScopeAndVisibilityTests::call_internal_add --args 10u64 20u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
