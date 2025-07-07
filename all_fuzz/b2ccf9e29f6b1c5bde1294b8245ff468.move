
//# publish
module 0xCAFE::Adder {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100
        } else {
            sum
        }
    }

    public fun lambda_test(a: u8, b: u8): u8 {
        let add = |x: u8, y: u8| x + y;
        let mul = |x: u8, y: u8| x * y;

        let sum = add(a, b);
        let product = mul(a, b);

        // Just return sum + product for some use.
        sum + product
    }

    // Removed `inline`
    public fun inline_increment(x: u8): u8 {
        x + 1
    }
}




//# run 0xCAFE::Adder::add_and_check --args 10u8 20u8




//# run 0xCAFE::Adder::lambda_test --args 3u8 4u8




//# run 0xCAFE::Adder::inline_increment --args 41u8




//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_inline_increment_twice(x: u8): u8 {
        let y = Adder::inline_increment(x);
        Adder::inline_increment(y)
    }
}




//# run 0xCAFE::NestedCall::call_inline_increment_twice --args 40u8
