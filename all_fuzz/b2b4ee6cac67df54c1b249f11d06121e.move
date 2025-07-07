
//# publish
module 0xCAFE::Calc {
    // Simple function to add two u8 values and return the sum plus 10
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function defining and using a lambda that multiplies two numbers and adds the first
    public fun lambda_usage(x: u8, y: u8): u8 {
        let mul_add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            (a * b) + a
        };
        mul_add(x, y)
    }
}


//# run 0xCAFE::Calc::add_with_offset --args 10u8 20u8


//# run 0xCAFE::Calc::lambda_usage --args 3u8 4u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Calc;

    // Calls the inline function add_with_offset from Calc twice and returns their sum
    // to test nested function calls across modules.
    public fun double_add(a: u8, b: u8, c: u8, d: u8): u8 {
        let first = Calc::add_with_offset(a, b);
        let second = Calc::add_with_offset(c, d);
        first + second
    }
}


//# run 0xCAFE::NestedCaller::double_add --args 1u8 2u8 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
