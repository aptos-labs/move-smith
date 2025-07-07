
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_special_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a special value if sum is greater than 10, otherwise return sum
        if (sum > 10) {
            42
        } else {
            sum
        }
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);
        product
    }
}



//# run 0xCAFE::LambdaModule::add_and_return_special_value --args 4u8 5u8



//# run 0xCAFE::LambdaModule::add_and_return_special_value --args 6u8 6u8



//# run 0xCAFE::LambdaModule::lambda_test --args 3u8 7u8




//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun nested_function_calls(a: u8, b: u8): u8 {
        let val1 = LambdaModule::add_and_return_special_value(a, b);
        let val2 = inline_increment(val1);
        val2
    }

    public fun run_nested_call() {
        let _ = nested_function_calls(5u8, 4u8);
        let _ = nested_function_calls(7u8, 7u8);
    }
}



//# run 0xCAFE::NestedCallModule::nested_function_calls --args 5u8 5u8



//# run 0xCAFE::NestedCallModule::nested_function_calls --args 8u8 5u8



//# run 0xCAFE::NestedCallModule::run_nested_call
