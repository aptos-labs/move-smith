
//# publish
module 0xCAFE::MathWithLambda {

    // Fixed add_then_check to return value properly
    public fun add_then_check(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value after addition to test simple computation and return
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun lambda_example(x: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, 5u8)
    }

    // Provide the inline function f2 in this module (since 0xCAFE::MyModule does not exist)
    public inline fun f2(x: u16): (u16, u16) {
        (x, x * 2)
    }

    public fun nested_inline_call(x: u16): (u16, u16) {
        // Call the inline function f2 within this module
        Self::f2(x)
    }

    public fun lambda_return_tuple(): (u8, u8) {
        let tuple_lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        tuple_lambda(3u8, 4u8)
    }
}



//# run 0xCAFE::MathWithLambda::add_then_check --args 6u8 7u8



//# run 0xCAFE::MathWithLambda::add_then_check --args 3u8 4u8



//# run 0xCAFE::MathWithLambda::lambda_example --args 10u8



//# run 0xCAFE::MathWithLambda::nested_inline_call --args 5u16



//# run 0xCAFE::MathWithLambda::lambda_return_tuple
