
//# publish
module 0xCAFE::Calc {
    /// Adds two u8 numbers and returns their sum plus 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Return a lambda that multiplies input by 2
    public fun get_double_lambda(): |u8|u8 has copy, drop {
        let lambda = |x: u8| {
            x * 2
        };
        lambda
    }

    /// Call a lambda that squares the input
    public fun use_lambda_square(x: u8, f: |u8|u8): u8 {
        f(x)
    }
}


//# publish
module 0xCAFE::Wrapper {
    use 0xCAFE::Calc;

    public inline fun inline_add_plus_ten(a: u8, b: u8): u8 {
        // Call Calc::add_and_offset and add 5 more
        let base = Calc::add_and_offset(a, b);
        base + 5
    }

    public fun run_nested_functions(a: u8, b: u8): u8 {
        // Use inline_add_plus_ten to get nested call result
        inline_add_plus_ten(a, b)
    }
}


//# publish
module 0xCAFE::VectorErrors {
    use std::vector;

    // expected_failure(vector_error, 42)]
    public fun trigger_vector_error() {
        let v = vector::empty<u8>();
        // Pop from empty vector will cause error
        let _ = vector::pop_back(&mut v);
    }
}


//# run 0xCAFE::Calc::add_and_offset --args 10u8 20u8


//# run 0xCAFE::Calc::get_double_lambda


//# run 0xCAFE::Calc::use_lambda_square --args 4u8 --args 16u8
// Note: Use a wrapper script for this if complex args not allowed;
// but here using direct call for demonstration per instructions.


//# run 0xCAFE::Wrapper::run_nested_functions --args 3u8 7u8


//# run 0xCAFE::VectorErrors::trigger_vector_error


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 438a5a28c4b3a3d65c2b6eb8f4ca3992: Indicate a vector operation error expected in your test with `#[expected_failure(vector_error)]` attribute, with optional minor status code.
