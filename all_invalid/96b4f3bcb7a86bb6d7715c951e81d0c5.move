//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Module with scripts acting as entry points
    public fun script_entry_point1(s: signer, param1: u8) {
        internal_logic1(param1);
    }

    public fun script_entry_point2(s: signer, param2: u16) {
        internal_logic2(param2);
    }

    // Internal functions to be invoked by scripts
    fun internal_logic1(x: u8) {
        assert!(x <= 255, 999);
    }

    fun internal_logic2(y: u16) {
        assert!(y >= 0 && y <= 65535, 998);
    }

    // Functions for loop variable scope and shadowing tests
    public fun loop_variable_tests() {
        let outer_var: u64 = 100;
        
        // For loop with inner variable shadowing
        let i: u64 = 0;
        for (i in 0..3) {
            // Shadow outer `i` inside loop
            let i = i + 10;
            // Inside loop, `i` should be the shadowed value
            assert!(i >= 10, 901);
        };
        // After loop, outer `i` should remain unchanged
        assert!(i == 0, 902);
        // outer_var should remain unchanged
        assert!(outer_var == 100, 903);
    }

    // Functions for variables inside and outside while loops with reassignment and shadowing
    public fun while_loop_variable_scope() {
        let x: u8 = 5;
        let y: u8 = 10;

        // First while loop
        let x_var: u8 = x; // mutable variable to simulate reassignment
        let y_var: u8 = y; // mutable variable to simulate mutation

        while (x_var < y_var) {
            let x_shadow = x_var + 1; // shadowed inside loop
            x_var = x_shadow; // update outer variable
            y_var = y_var - 1; // mutate outer y
            assert!(x_var >= 5 && x_var <= 11, 904);
        };

        // After loop, check values
        assert!(x_var == 6 || x_var == 5, 905); // outer x may have increased by loop
        assert!(y_var == 10 || y_var == 5, 906); // mutated y value

        // Second loop with shadowed variable
        let z: u8 = 2;
        let z_shadow = z; // shadowing z with mutable variable
        while (z_shadow < 4) {
            z_shadow = z_shadow + 1; // shadowed inside loop, update z_shadow
        };
        // Confirm that outer z remains unchanged
        assert!(z == 2, 907);
    }

    // Functions demonstrating internal visibility restrictions
    fun internal_private_function() {
        // just a dummy internal function
    }

    public fun try_access_internal_function() {
        // Attempt to call internal function from outside; should fail if uncommented
        // internal_private_function(); // This should produce compile error if uncommented
    }

    // Expose a public function that internally calls internal functions
    public fun invoke_internal_function() {
        internal_private_function();
    }
}



//# run 0xCAFE::TestModule::script_entry_point1 --signers 0xBEEF --args 255u8



//# run 0xCAFE::TestModule::script_entry_point2 --signers 0xBEEF --args 65535u16



//# run 0xCAFE::TestModule::loop_variable_tests



//# run 0xCAFE::TestModule::while_loop_variable_scope



//# run 0xCAFE::TestModule::invoke_internal_function


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
