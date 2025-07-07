
//# publish
module 0xCAFE::LambdaTest {
    /// A public function that adds two u8 numbers and returns u8
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    /// A function that uses a lambda (anonymous function) to multiply two numbers and returns the result
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiply: |(u8, u8), u8| has copy + drop = |(x, y): (u8, u8)| {
            x * y
        };
        multiply((a, b))
    }

    /// A function that takes a lambda with no arguments returning u8,
    /// calls it and returns the result.
    public fun call_lambda_no_args(f: |(): u8|): u8 {
        f()
    }

    /// Exposes a runner that internally calls a lambda with no args
    public fun runner_lambda_no_args(): u8 {
        let f: |(): u8| has copy + drop = || { 42u8 };
        call_lambda_no_args(f)
    }
}



//# publish
module 0xCAFE::InlineFunc {
    /// An inline function that doubles a u16 input and returns it
    public inline fun double(a: u16): u16 {
        a * 2
    }

    /// A public function that calls the inline function and adds 1
    public fun double_plus_one(a: u16): u16 {
        let doubled = double(a);
        doubled + 1
    }
}



//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::InlineFunc;
    use 0xCAFE::LambdaTest;

    /// Public function calls inline function from InlineFunc and returns the result
    public fun nested_call(a: u16): u16 {
        InlineFunc::double_plus_one(a)
    }

    /// Public function calls add_and_return_sum then multiply_lambda and returns sum + mul
    public fun call_lambda_add_mul(a: u8, b: u8): u8 {
        let sum = LambdaTest::add_and_return_sum(a, b);
        let product = LambdaTest::multiply_lambda(a, b);
        sum + product
    }

    /// Public function that demonstrates calling lambda runner from LambdaTest
    public fun call_runner_lambda_no_args(): u8 {
        LambdaTest::runner_lambda_no_args()
    }
}
