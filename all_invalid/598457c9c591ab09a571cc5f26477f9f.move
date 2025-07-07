
//# publish
module 0xCAFE::SyntaxErrorTest {
    use std::debug;

    public fun test_syntax_error() acquires {
        // intentionally invalid syntax to test detailed error messages
        // missing a comma between import and the function
        // The following line is invalid Move syntax and should produce an error.
        import 0xCAFE::MyModule
    }

    public fun test_function(p: u8): u8 {
        let _x;

        let _ = self::one(p);

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


//# run 0xCAFE::SyntaxErrorTest::test_syntax_error


//# run 0xCAFE::SyntaxErrorTest::test_function --args 5u8
// This will verify that after calling `one`, the value of p is assigned to _x and returned


//# run 0xCAFE::SyntaxErrorTest::test_conditional --args true
// should return 42


//# run 0xCAFE::SyntaxErrorTest::test_conditional --args false
// should return 24

// Featurres:
// dcfe7e9ea3e15dc8ee65423322a544f4: Receive detailed error messages specifying the unexpected token and what was expected when there is a syntax error in your Move code.
// 82192e1c5121e4531b7cb24f03120b62: Test that the `test` function correctly assigns the input parameter `p` to the local variable `_x` after calling the `one` function and returns the value of `_x`.
// f020765f96160effa4351ae0e6b2c22f: Create conditional expressions with 'if-else' branches.
