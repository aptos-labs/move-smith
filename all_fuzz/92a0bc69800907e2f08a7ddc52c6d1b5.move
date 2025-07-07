
//# publish
module 0xCAFE::LambdaTest {
    public inline fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;

        let checker: |u8| bool has copy+drop = |val: u8| {
            val == sum
        };
        if (checker(sum)) {
            42u8
        } else {
            0u8
        }
    }

    public inline fun apply_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_add_and_return_special(x: u8, y: u8): u8 {
        LambdaTest::add_and_return_special(x, y)
    }

    public inline fun call_apply_lambda(x: u8, y: u8): (u8, u8) {
        LambdaTest::apply_lambda(x, y)
    }

    public fun runner() {
        let _a = call_add_and_return_special(10u8, 32u8);
        let (_b, _c) = call_apply_lambda(6u8, 7u8);
    }
}
