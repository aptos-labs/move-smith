module 0xCAFE::SyntaxErrorTest {
    use std::debug;

    // Fixed: Removed the incorrect 'acquires' keyword from the function declaration.
    // Original: public fun test_syntax_error() acquires {
    // Corrected: public fun test_syntax_error() {
    public fun test_syntax_error() {
        // intentionally invalid syntax to test detailed error messages
        // missing a comma between import and the function
        // The following line is invalid Move syntax and should produce an error.
        import 0xCAFE::MyModule
    }

    public fun test_function(p: u8): u8 {
        let _x: u8;

        let _ = Self::one(p); // Use Self:: to call helper function

        // Test assignment after function call
        _x = p;

        // Return the value of _x
        _x
    }

    // Helper function to be called within test_function
    public fun one(val: u8): u8 {
        val
    }

    public fun test_conditional(x: bool): u8 {
        // Create conditional expressions with if-else branches.
        if (x) {
            42u8
        } else {
            24u8
        }
    }
}