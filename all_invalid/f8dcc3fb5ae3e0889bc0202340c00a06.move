
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use std::vector;

    // Function with local variables and loops, testing variable shadowing and scope
    public fun test_variable_scope_and_shadowing() {
        let x: u64 = 1;
        let y: u64 = 2;
        if (x == 1) {
            let x: u64 = 10; // shadow outer x
            y = y + x; // y becomes 12
        }; // Must end with semicolon
        // After if:
        // x should still be 1, y is 12
        assert!(x == 1, 1);
        assert!(y == 12, 2);
    }

    // Function that uses while loop with local variable
    public fun test_while_loop() {
        let count: u64 = 0;
        let sum: u64 = 0;
        while (count < 5) {
            // shadow count inside loop
            let count: u64 = count + 1;
            sum = sum + count;
        }; // Must end with semicolon
        // count outside should be unchanged
        assert!(count == 0, 3);
        assert!(sum == 15, 4); // sum of 1..5
    }

    // Test internal (private) and public functions
    public fun call_internal_functions() {
        let value = internal_add(5, 7);
        assert!(value == 12, 5);
    }

    // Internal function, only accessible within module
    fun internal_add(a: u64, b: u64): u64 {
        a + b
    }

    // Function to test cross-module call restriction
    public fun cross_module_call() {
        // Should not be able to call internal_add from another module directly
        // But here, it's within the same module, so allowed
        let sum = internal_add(2, 3);
        assert!(sum == 5, 6);
    }

    // Spec function with native declaration
    native fun native_spec_func(); // Correct syntax: native fun declaration ends with ';'

    // Fully implemented spec function
    public fun spec_function() {
        native_spec_func();
    }

    // Function with restricted visibility (private), should not be callable outside
    fun private_helper() {
        // do nothing
    }

    // Function attempting to call private or forbidden functions
    public fun test_call_restrictions() {
        // can call public functions
        let _ = self::internal_add(1, 2);
        // cannot call private_helper() here as it's private and within same module
        // but from external modules, only public functions are accessible
    }
}



//# run 0xCAFE::TestInteraction::test_variable_scope_and_shadowing


//# run 0xCAFE::TestInteraction::test_while_loop


//# run 0xCAFE::TestInteraction::call_internal_functions


//# run 0xCAFE::TestInteraction::cross_module_call


//# run 0xCAFE::TestInteraction::test_call_restrictions


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 40dd5f2d2d0593977243d4dde78a926d: Choose between native spec functions (no body) and defined spec functions (with a statement sequence body).
// e808b7b2dd1febca61fb15c97aec58af: Restrict function calls to only access functions with the appropriate visibility (public, friend, or private).
