
//# publish
module 0xCAFE::AddAndCompute {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;

        let lambda: |u8|bool has copy+drop = |x: u8| {
            x > 0
        };
        if (lambda(sum)) {
            42u8
        } else {
            0u8
        }
    }

    // inline function f2 is not defined in this module, but we mimic similar for our test
    public inline fun add_and_check_inline_wrapper(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Runner function using simple arguments
    public fun runner() {
        let _ = add_and_check(10u8, 32u8);
    }
}



//# run 0xCAFE::AddAndCompute::runner



//# publish
module 0xCAFE::LambdasExample {
    public fun test_lambda_expr(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = add_lambda(x, y);
        let product = mul_lambda(x, y);
        (sum, product)
    }

    public fun runner() {
        let (_sum, _product) = test_lambda_expr(7u8, 6u8);
    }
}



//# run 0xCAFE::LambdasExample::runner



//# publish
module 0xCAFE::ExternalInlineCall {
    use 0xCAFE::AddAndCompute;

    // Call inline function f2 from AddAndCompute by defining a trivial wrapper here to test nested calls
    public fun call_inline_and_add(a: u16): u16 {
        let (x, y) = AddAndCompute::add_and_check_inline_wrapper(a);
        x + y
    }

    public fun runner() {
        let _ = call_inline_and_add(20u16);
    }
}



//# run 0xCAFE::ExternalInlineCall::runner
