
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and return a specific value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    // Function containing a lambda that multiplies and adds
    public fun compute_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 5u8
        };
        lambda(x, y)
    }

    // Inline function returning a tuple
    public inline fun inline_add(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    public fun call_add_and_lambda(a: u8, b: u8, c: u8, d: u8): (u8, u8, u8) {
        let fixed_val = AddAndLambda::add_and_return_fixed(a, b);
        let lambda_val = AddAndLambda::compute_with_lambda(c, d);
        let (sum, mul) = AddAndLambda::inline_add(a, d);
        (fixed_val, lambda_val, sum + mul)
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return_fixed --args 7u8 5u8



//# run 0xCAFE::AddAndLambda::add_and_return_fixed --args 3u8 4u8



//# run 0xCAFE::AddAndLambda::compute_with_lambda --args 3u8 4u8



//# run 0xCAFE::NestedCalls::call_add_and_lambda --args 7u8 5u8 3u8 4u8
