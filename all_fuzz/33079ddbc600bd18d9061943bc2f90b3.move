
//# publish
module 0xCAFE::AddAndLambda {
    // A simple function to add two u8 values and then add 10 to the sum before returning.
    public fun add_then_add_ten(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // A function that uses a lambda to multiply two u16 values and then add 5 to the result.
    public fun lambda_multiply_then_add(a: u16, b: u16): u16 {
        // Fixed lambda syntax by removing 'has copy+drop'
        let multiply = |x: u16, y: u16| {
            x * y
        };
        let product = multiply(a, b);
        product + 5u16
    }

    // Runner function for no-arg calls
    public fun runner() {
        let _ = add_then_add_ten(3u8, 7u8);
        let _ = lambda_multiply_then_add(4u16, 6u16);
    }
}



//# publish
module 0xCAFE::InlineCall {
    // Instead of `use`, import functions directly with fully qualified names
    // since the error was unbound module on `use`.

    // Inline function returning a tuple (x + y, x * y)
    public inline fun tuple_operation(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }

    // A function that calls a public inline function from AddAndLambda module for nested function calls
    public fun nested_call(a: u8, b: u8, c: u16, d: u16): (u8, u16) {
        let add_result = 0xCAFE::AddAndLambda::add_then_add_ten(a, b);
        let lambda_result = 0xCAFE::AddAndLambda::lambda_multiply_then_add(c, d);
        (add_result, lambda_result)
    }

    public fun run_inline() {
        // Assign tuple elements to variables separately (cannot assign tuple to single var)
        let (sum, product) = tuple_operation(2u8, 5u8);
        // Ignore variables to avoid unused variable warnings if needed
        let _ = sum;
        let _ = product;
    }
}



//# run 0xCAFE::AddAndLambda::add_then_add_ten --args 5u8 6u8



//# run 0xCAFE::AddAndLambda::lambda_multiply_then_add --args 7u16 8u16



//# run 0xCAFE::AddAndLambda::runner



//# run 0xCAFE::InlineCall::nested_call --args 3u8 4u8 5u16 6u16



//# run 0xCAFE::InlineCall::run_inline
