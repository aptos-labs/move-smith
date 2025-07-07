






//# run 0xCAFE::MyModule::f4 --signers 0xBEEF


//# run 0xCAFE::MyModule::f5


//# run 0xCAFE::MyModule::f6 --args |u8|u8{|a: u8| a + 1} --args 10u8


//# run 0xCAFE::MyModule::f7

// Testing Arithmetic Operations on u16

// Normal addition

//# run 0xCAFE::MyModule::f8_add --args 65535u16 1u16

// Addition overflow (expected to overflow or panic depending on VM settings)

//# run 0xCAFE::MyModule::f8_add --args 65535u16 2u16

// Normal subtraction

//# run 0xCAFE::MyModule::f8_sub --args 100u16 50u16

// Subtraction underflow (since no negative, expect wrap or panic)

//# run 0xCAFE::MyModule::f8_sub --args 0u16 1u16

// Normal multiplication

//# run 0xCAFE::MyModule::f8_mul --args 300u16 2u16

// Multiplication overflow

//# run 0xCAFE::MyModule::f8_mul --args 65535u16 2u16

// Normal division

//# run 0xCAFE::MyModule::f8_div --args 1000u16 10u16

// Division by zero (should panic or abort)

//# run 0xCAFE::MyModule::f8_div --args 100u16 0u16

// Normal modulo

//# run 0xCAFE::MyModule::f8_mod --args 100u16 30u16

// Modulo by zero (should panic or abort)

//# run 0xCAFE::MyModule::f8_mod --args 100u16 0u16

// Additional functions for testing operations
//# publish
module 0xCAFE::MyModule {
    // Function to test addition with boundary values
    public fun f8_add(a: u16, b: u16): u16 {
        a + b
    }

    // Function to test subtraction with boundary values
    public fun f8_sub(a: u16, b: u16): u16 {
        a - b
    }

    // Function to test multiplication with boundary values
    public fun f8_mul(a: u16, b: u16): u16 {
        a * b
    }

    // Function to test division with boundary values
    public fun f8_div(a: u16, b: u16): u16 {
        assert!(b != 0, 999);
        a / b
    }

    // Function to test modulo with boundary values
    public fun f8_mod(a: u16, b: u16): u16 {
        assert!(b != 0, 999);
        a % b
    }
}


// Featurres:
// c8de81a90235cd6c38cd55195b35a838: Call functions with positional or receiver (method-call) syntax.
// cd6efccaaa22ee0f4bc4a974802d383c: Specify function parameters separated by commas within parentheses.
// c85a1e84234e716f1bfd9fd0ba0b18a2: Test that all arithmetic operations—addition, subtraction, multiplication, division, and modulo—on the u16 integer type correctly handle normal cases, edge cases, and overflow/underflow or division-by-zero errors according to Move language semantics.
