
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // return 42 if sum matches 42, otherwise return sum
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8): u8 {
        let add_ten: |u8|u8 has copy+drop = |n: u8| {
            n + 10
        };
        add_ten(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun test_lambda_from_other_module(x: u8): u8 {
        AddModule::lambda_example(x)
    }
}



//# run 0xCAFE::AddModule::add_two_values --args 20u8 22u8



//# run 0xCAFE::AddModule::add_two_values --args 10u8 5u8



//# run 0xCAFE::AddModule::lambda_example --args 5u8



//# run 0xCAFE::CallerModule::call_inline_add --args 15u8 27u8



//# run 0xCAFE::CallerModule::test_lambda_from_other_module --args 7u8
