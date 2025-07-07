
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_check(a: u8, b: u8): u8 {
        let c = a + b;
        // Return a fixed value if addition equals a certain number, else return sum
        if (c == 10) {
            42u8
        } else {
            c
        }
    }

    public fun run_lambda_examples(): (u8, u8) {
        let lambda: |u8,u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let result = lambda(3u8, 4u8);

        let captured = 5u8;
        let add_captured_lambda: |u8| u8 has copy+drop = |v: u8| { captured + v };

        let sum_captured = add_captured_lambda(10u8);

        (result, sum_captured)
    }
}



//# run 0xCAFE::TestAdd::add_and_check --args 4u8 6u8



//# run 0xCAFE::TestAdd::run_lambda_examples



//# publish
module 0xCAFE::TestInlineCalls {
    use 0xCAFE::TestAdd;

    public inline fun inline_add(a: u8, b: u8): u8 {
        // call external inline function (simulate by calling normal function here)
        TestAdd::add_and_check(a, b)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let res = inline_add(a, b);
        res
    }
}



//# run 0xCAFE::TestInlineCalls::nested_call --args 7u8 3u8



//# publish
module 0xCAFE::PatternBindingUtil {
    struct Wrapper has copy, drop {
        value: u8
    }

    struct OptionU8 has copy, drop {
        inner: u8,
        is_some: bool
    }

    fun to_option(input: u8): OptionU8 {
        if (input > 5) {
            OptionU8 { inner: input, is_some: true }
        } else {
            OptionU8 { inner: 0u8, is_some: false }
        }
    }

    public fun try_convert_and_bind(x: u8): u8 {
        let opt = to_option(x);
        if (opt.is_some) {
            let val = opt.inner;
            val + 10u8
        } else {
            0u8
        }
    }
}



//# run 0xCAFE::PatternBindingUtil::try_convert_and_bind --args 4u8



//# run 0xCAFE::PatternBindingUtil::try_convert_and_bind --args 6u8
