
//# publish
module 0xCAFE::Calc {
    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 if sum > 10, else sum
        if (sum > 10) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let product = lambda(6u8, 7u8);
        product
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun nested_inline_add(a: u8, b: u8, c: u8): u8 {
        let ab = Calc::inline_add(a, b);
        let abc = Calc::inline_add(ab, c);
        abc
    }

    public fun use_lambda(): u8 {
        Calc::lambda_example()
    }
}



//# run 0xCAFE::Calc::add_and_return_specific --args 5u8 6u8



//# run 0xCAFE::Calc::add_and_return_specific --args 4u8 5u8



//# run 0xCAFE::Calc::lambda_example



//# run 0xCAFE::Caller::nested_inline_add --args 3u8 4u8 5u8



//# run 0xCAFE::Caller::use_lambda
