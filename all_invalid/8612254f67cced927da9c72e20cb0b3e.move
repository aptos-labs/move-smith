
//# publish
module 0xCAFE::SpecRewriteTest {
    use std::vector;
    use std::signer;

    // A struct to test complex param and return
    struct Data has copy, drop, store {
        a: u8,
        b: vector<u8>,
    }

    // Inline accessible function
    public(inline) fun accessible_inline_function(x: u8, y: u8): (u8, u8) {
        // Returns tuple
        (x + 1, y + 1)
    }

    // Inline non-accessible function
    fun non_accessible_inline_function(x: u8): u8 {
        x * 2
    }

    // Public function calls accessible inline and non-accessible inline functions
    public fun caller_functions(x: u8, y: u8): (u8, u8, u8) {
        // Call accessible inline function - allowed
        let (a, b) = accessible_inline_function(x, y);

        // Call non-accessible inline function - allowed since within module
        let c = non_accessible_inline_function(a);

        (a, b, c)
    }

    // Function that generates and tracks temps for parameters and returns multiple times
    public fun param_return_temps(x: u8, y: u8): u8 {
        let (a1, b1) = accessible_inline_function(x, y);
        let (a2, b2) = accessible_inline_function(b1, a1);
        let sum = a2 + b2 + x + y;
        sum
    }

    // A struct level specification rewritten for testing
    spec struct Data {
        // Spec function rewritten (dummy example)
        fun spec_add(d: Data): u8 { d.a + vector::length(&d.b) }
    }

    // Function-level specification rewritten for testing
    spec fun caller_functions(x: u8, y: u8): (u8, u8, u8) {
        ensures let (a, b, c) = caller_functions(x, y);
        a > 0 && b > 0 && c > 0;
    }

    // Positive test: public access inline function call from outside module (should be allowed)
    public fun public_inline_caller_outside(x: u8, y: u8): (u8, u8) {
        accessible_inline_function(x, y)
    }

    // Negative test: try to call non accessible inline function from outside (simulated)
    // Since this cannot be called publicly, we simulate failure by documenting as comment

    // Run wrapper for caller_functions with no signers or args other than primitives
    public fun run_caller_functions(): (u8, u8, u8) {
        caller_functions(10u8, 20u8)
    }

    // Run wrapper for param_return_temps with no signers
    public fun run_param_return_temps(): u8 {
        param_return_temps(2u8, 3u8)
    }
}


//# run 0xCAFE::SpecRewriteTest::accessible_inline_function --args 5u8 6u8


//# run 0xCAFE::SpecRewriteTest::caller_functions --args 5u8 6u8


//# run 0xCAFE::SpecRewriteTest::param_return_temps --args 1u8 2u8


//# run 0xCAFE::SpecRewriteTest::run_caller_functions


//# run 0xCAFE::SpecRewriteTest::run_param_return_temps


//# run 0xCAFE::SpecRewriteTest::public_inline_caller_outside --args 7u8 8u8


// Featurres:
// 0331f48fa3a869adb5cce5f5a20ba73b: Ensure that only accessible inline functions can be called before inlining.
// 5c5cd022a0ae658e161cf5429140e791: Handle function parameters and return types by creating and tracking temporary variables.
// b55ad2e03b67074aa23a762dfdf31657: Rewrite specifications for Move modules and functions to improve or transform them
