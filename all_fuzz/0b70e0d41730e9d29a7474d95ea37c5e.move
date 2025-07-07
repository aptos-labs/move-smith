
//# publish
module 0xCAFE::MathModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        f(x)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}



//# run 0xCAFE::MathModule::add_two_values --args 3u8 4u8



//# run 0xCAFE::MathModule::add_two_values --args 6u8 7u8



//# run 0xCAFE::MathModule::lambda_example --args 5u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        let sum = MathModule::inline_adder(x, y);
        sum + 1u8
    }

    public fun call_add_two_and_lambda(x: u8, y: u8): u8 {
        let base = MathModule::add_two_values(x, y);
        let doubled = MathModule::lambda_example(base);
        doubled
    }
}



//# run 0xCAFE::CallerModule::call_inline_add --args 2u8 3u8



//# run 0xCAFE::CallerModule::call_add_two_and_lambda --args 3u8 4u8
