
//# publish
module 0xCAFE::CalcModule {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value if sum is over 10
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_double(a: u8): u8 {
        a * 2
    }

    public fun nested_inline_call(x: u8): u8 {
        let doubled = inline_double(x);
        add_two_u8(doubled, 5u8)
    }
}



//# run 0xCAFE::CalcModule::add_two_u8 --args 3u8 4u8



//# run 0xCAFE::CalcModule::add_two_u8 --args 7u8 5u8



//# run 0xCAFE::CalcModule::lambda_example --args 9u8 1u8



//# run 0xCAFE::CalcModule::nested_inline_call --args 4u8


// NOTE: CallerModule must be published after CalcModule, so combine code below in one file or ensure proper ordering


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let doubled = CalcModule::inline_double(a);
        let sum = CalcModule::lambda_example(doubled, b);
        sum
    }
}



//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 3u8 5u8
