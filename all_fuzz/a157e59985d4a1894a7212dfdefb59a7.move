
//# publish
module 0xCAFE::LambdaTest {
    /// A simple function that adds two u8 values and returns the sum plus a constant
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    /// A function demonstrating a lambda that adds two u8 values
    public fun run_lambda_add(a: u8, b: u8): u8 {
        let add_fn: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_fn(a, b)
    }

    /// A function demonstrating lambda that returns tuple of sums and products
    public fun run_lambda_tuple(a: u8, b: u8): (u8, u8) {
        let compute: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| { (x + y, x * y) };
        compute(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 5u8 7u8


//# run 0xCAFE::LambdaTest::run_lambda_add --args 3u8 4u8


//# run 0xCAFE::LambdaTest::run_lambda_tuple --args 2u8 6u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    /// Calls add_and_offset from LambdaTest and then calls run_lambda_add, returns sum of results
    public fun call_nested_functions(x: u8, y: u8): u8 {
        let first = LambdaTest::add_and_offset(x, y);
        let second = LambdaTest::run_lambda_add(x, y);
        first + second
    }
}


//# run 0xCAFE::InlineCaller::call_nested_functions --args 10u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
