
//# publish
module 0xCAFE::FuncAndLambdaTest {
    use std::signer;

    // Simple add function that returns sum + 10
    public fun add_with_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // Function that uses lambda to multiply then add fixed 5
    public fun lambda_multiply_add(x: u8, y: u8): u8 {
        let mult_add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let mul = a * b;
            mul + 5
        };
        mult_add(x, y)
    }

    // Function that calls an inline function inside this module
    public inline fun inline_double(a: u8): u8 {
        a * 2
    }

    // Runner to test inline function
    public fun run_inline(a: u8): u8 {
        inline_double(a)
    }
}


//# run 0xCAFE::FuncAndLambdaTest::add_with_offset --args 20u8 22u8


//# run 0xCAFE::FuncAndLambdaTest::lambda_multiply_add --args 7u8 6u8


//# run 0xCAFE::FuncAndLambdaTest::run_inline --args 15u8



//# publish
module 0xF00D::NestedCallsTest {
    use 0xCAFE::FuncAndLambdaTest;

    // Calls FuncAndLambdaTest::add_with_offset and multiplies by 2
    public fun nested_add_mul(a: u8, b: u8): u8 {
        let tmp = FuncAndLambdaTest::add_with_offset(a, b);
        tmp * 2
    }

    // Calls lambda_multiply_add inside FuncAndLambdaTest and subtracts 3
    public fun nested_lambda_subtract(a: u8, b: u8): u8 {
        let tmp = FuncAndLambdaTest::lambda_multiply_add(a, b);
        tmp - 3
    }

    // Calls run_inline inside FuncAndLambdaTest and adds 4
    public fun nested_inline_add(a: u8): u8 {
        let tmp = FuncAndLambdaTest::run_inline(a);
        tmp + 4
    }
}


//# run 0xF00D::NestedCallsTest::nested_add_mul --args 10u8 5u8


//# run 0xF00D::NestedCallsTest::nested_lambda_subtract --args 3u8 4u8


//# run 0xF00D::NestedCallsTest::nested_inline_add --args 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
