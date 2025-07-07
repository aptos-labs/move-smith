
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_u8s(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_seven(a: u8, b: u8): u8 {
        let sum = add_two_u8s(a, b);
        // Return 7 if sum matches 7, else return sum
        if (sum == 7) {
            7
        } else {
            sum
        }
    }

    public fun lambda_test_single(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |z: u8| {
            z + 1
        };
        lambda(x)
    }

    public fun lambda_test_double(x: u8, y: u8): (u8, u8) {
        let lambda_xy: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda_xy(x, y)
    }
}



//# run 0xCAFE::AdditionModule::add_two_u8s --args 3u8 4u8



//# run 0xCAFE::AdditionModule::add_and_return_seven --args 3u8 4u8



//# run 0xCAFE::AdditionModule::lambda_test_single --args 5u8



//# run 0xCAFE::AdditionModule::lambda_test_double --args 3u8 4u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Calls AdditionModule::add_two_u8s inline and then adds 1
        let sum = AdditionModule::add_two_u8s(a, b);
        sum + 1
    }

    public fun use_lambda_from_addition_module(x: u8, y: u8): (u8, u8) {
        AdditionModule::lambda_test_double(x, y)
    }

    public fun nested_call_test(a: u8, b: u8): u8 {
        let val = call_inline_add(a, b);
        // If val >= 5, return val, else return 5
        if (val >= 5) {
            val
        } else {
            5
        }
    }
}



//# run 0xCAFE::CallerModule::call_inline_add --args 2u8 3u8



//# run 0xCAFE::CallerModule::use_lambda_from_addition_module --args 4u8 5u8



//# run 0xCAFE::CallerModule::nested_call_test --args 1u8 2u8
