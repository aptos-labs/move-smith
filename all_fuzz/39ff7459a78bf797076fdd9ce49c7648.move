
//# publish
module 0xCAFE::LambdaTest {
    /// Add two u8 values and then add 10, returning the result
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let offset = 10;
        sum + offset
    }

    /// Function demonstrating lambda that multiplies x by 2
    public fun double_using_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |val: u8| {
            val * 2
        };
        lambda(x)
    }

    /// Function demonstrating lambda that uses two inputs and returns their sum and product
    public fun sum_and_product_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::LambdaTest;

    /// Call the inline addition with offset function in LambdaTest
    public fun call_add_and_offset(a: u8, b: u8): u8 {
        LambdaTest::add_and_offset(a, b)
    }

    /// Call the double_using_lambda function from LambdaTest
    public fun call_double_using_lambda(x: u8): u8 {
        LambdaTest::double_using_lambda(x)
    }

    /// Call the sum_and_product_lambda function from LambdaTest and return sum (first element)
    public fun call_sum_and_product_lambda(a: u8, b: u8): u8 {
        let (sum, _prod) = LambdaTest::sum_and_product_lambda(a, b);
        sum
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 3u8 5u8


//# run 0xCAFE::LambdaTest::double_using_lambda --args 7u8


//# run 0xCAFE::LambdaTest::sum_and_product_lambda --args 3u8 4u8


//# run 0xCAFE::CallInline::call_add_and_offset --args 8u8 12u8


//# run 0xCAFE::CallInline::call_double_using_lambda --args 10u8


//# run 0xCAFE::CallInline::call_sum_and_product_lambda --args 9u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
