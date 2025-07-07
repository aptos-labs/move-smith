
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_val(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun apply_lambda_to_args(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::LambdaTest::add_then_return_val --args 5u8 7u8



//# run 0xCAFE::LambdaTest::apply_lambda_to_args --args 3u8 4u8


// publish LambdaTest module first, then NestedCallTest module

//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun inline_increment(x: u16): u16 {
        x + 1
    }

    public fun call_inline_and_lambda(a: u8, b: u8, x: u16): (u8, u8, u16) {
        let (add_res, mul_res) = LambdaTest::apply_lambda_to_args(a, b);
        let inc_res = inline_increment(x);
        (add_res, mul_res, inc_res)
    }
}



//# run 0xCAFE::NestedCallTest::call_inline_and_lambda --args 2u8 5u8 99u16
