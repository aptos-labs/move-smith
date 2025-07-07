
//# publish
module 0xCAFE::TestLambdas {
    // Removed unused use std::signer;

    public fun add_two_and_return_result(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) { 42u8 } else { 24u8 };
        result
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        let c = add_lambda(a, b);
        c
    }

    public fun lambda_capture(x: u8): u8 {
        let captured = x;
        let lambda: |u8| u8 has copy+drop = |y: u8| captured + y;
        lambda(10u8)
    }

    public fun lambda_reassign() {
        let lambda: |u8| u8 has copy+drop = |x: u8| x + 1;
        let copy_lambda = copy lambda;
        let _ = lambda(1u8);
        // Shadows lambda with reassignment but the new lambda is not used.
        // Consume _lambda explicitly to avoid implicit drop error.
        let _lambda = |x: u8| x + 2;
        // Unpack the closure by applying it once, consumes _lambda.
        let _ = _lambda(0u8);
        // Ensure copy_lambda still behaves as original
        let _ = copy_lambda(1u8);
    }
}



//# publish
module 0xCAFE::TestInlineCalls {
    use 0xCAFE::TestLambdas;

    public inline fun inlined_addition(a: u8, b: u8): u8 {
        let s = a + b;
        s
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let inline_result = inlined_addition(a, b);
        let lambda_result = TestLambdas::lambda_add(a, b);
        inline_result + lambda_result
    }
}




//# run 0xCAFE::TestLambdas::add_two_and_return_result --args 3u8 4u8


//# run 0xCAFE::TestLambdas::lambda_add --args 5u8 7u8


//# run 0xCAFE::TestLambdas::lambda_capture --args 8u8


//# run 0xCAFE::TestLambdas::lambda_reassign


//# run 0xCAFE::TestInlineCalls::call_inline_and_lambda --args 10u8 15u8
