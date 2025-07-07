
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    // Function to add two u8 values and then add 10 to the sum and return it
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function that contains a lambda that multiplies two u8 integers
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    // Function that takes a lambda from caller and applies it to two u8 values
    // Note: lambda arguments cannot be passed as values directly in transactions.
    // So this function is not usable directly from CLI with a lambda argument.
    // Common practice: pass predefined lambdas or use a wrapper call.
    public fun apply_lambda(lambda: |u8, u8|u8, a: u8, b: u8): u8 {
        lambda(a, b)
    }
}



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaTest;

    // Inline function returning square of a number
    public inline fun square(x: u8): u8 {
        x * x
    }

    // Public function that calls LambdaTest::add_with_offset and then calls square inline function on the result
    public fun combined_add_and_square(a: u8, b: u8): u8 {
        let added = LambdaTest::add_with_offset(a, b);
        square(added)
    }
}



//# run 0xCAFE::LambdaTest::add_with_offset --args 3u8 4u8


//# run 0xCAFE::LambdaTest::multiply_lambda --args 6u8 7u8


//# run 0xCAFE::NestedInlineCall::combined_add_and_square --args 3u8 4u8

// Removed the invalid lambda argument from the run command - lambdas cannot be passed as transaction args.

//# run 0xCAFE::LambdaTest::apply_lambda --args 2u8 3u8
