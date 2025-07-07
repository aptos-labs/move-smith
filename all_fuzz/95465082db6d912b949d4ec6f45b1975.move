
//# publish
module 0xCAFE::Computation {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42
        } else {
            sum
        }
    }

    public fun call_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(6u8, 7u8)
    }

    public inline fun inline_adder(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }
}



//# run 0xCAFE::Computation::add_and_check --args 5u8 6u8



//# run 0xCAFE::Computation::add_and_check --args 3u8 4u8



//# run 0xCAFE::Computation::call_lambda_example




//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Computation;

    public fun call_inline_nested(): u8 {
        let (a, b) = Computation::inline_adder(4u8, 8u8);
        if (b > 10) {
            a
        } else {
            b
        }
    }
}



//# run 0xCAFE::NestedCaller::call_inline_nested
