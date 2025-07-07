
//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Entry point script function to call internal functions
    public fun run_tests() {
        // Call variable handling and shadowing tests
        internal_variable_shadowing();
        variable_after_loop();
        variable_shadowing_scope();

        // Call function visibility tests
        internal_function_accessibility();

        // Call functions involving variable shadowing and preservation
        let result = variable_preservation_after_loop(5u8);
        assert!(result == 5u8, 0);
    }

    // Internal function for testing variable shadowing
    fun internal_variable_shadowing() {
        let x = 10u64;
        let x = 20u64; // Shadowing outer x
        assert!(x == 20u64, 1);
        // Shadowing local to this block
        let y = 30u64;
        let y = y + 5; // Shadow y
        assert!(y == 35u64, 2);
        // Outer x should remain untouched
        assert!(x == 20u64, 3);
        // Outer y does not exist
        // No external access here
    }

    // Function to test that variables retain their values after a loop
    fun variable_after_loop(start: u8): u8 {
        let x = start;
        while (x < 10u8) {
            x = x + 1;
        };
        // After loop, x should be >=10
        x
    }

    // Function to test shadowing in scope
    fun variable_shadowing_scope() {
        let a = 1u8;
        let a = {
            let a = 2u8; // Shadow in inner block
            a
        };
        assert!(a == 1u8, 4); // Outer a remains 1
    }

    // Function only accessible within this module
    fun internal_function_accessibility() {
        // Call an internal function
        let val = internal_const_value();
        assert!(val == 42u64, 5);
    }

    // Move does not support 'internal' visibility specifier.
    // Instead, all functions are private by default unless 'public'.
    // To simulate internal, just keep the function private.

    fun internal_const_value(): u64 {
        42u64
    }

    // Function that modifies a variable in loop and returns it to test preservation
    public fun variable_preservation_after_loop(x: u8): u8 {
        let y = x;
        // copy y is unnecessary, but can be added if needed
        while (y < 10u8) {
            y = y + 1;
        };
        y // Should be 10 after loop
    }
}



//# run 0xCAFE::TestModule::run_tests
