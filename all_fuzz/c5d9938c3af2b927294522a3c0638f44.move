
//# publish
module 0xCAFE::LambdaModule {
    public fun add_two_numbers(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) { 10 } else { sum };
        result
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let res = add_lambda(x, y);
        res
    }

    public fun nested_lambda(x: u8): u8 {
        let inner_lambda: |u8|u8 has copy+drop = |v: u8| {
            v + 1
        };
        let outer_lambda: |u8|u8 has copy+drop = |w: u8| {
            inner_lambda(w) * 2
        };
        outer_lambda(x)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    // Changed inline function to public to fix FUNCTION_RESOLUTION_FAILURE
    public fun call_inline_add(x: u8, y: u8): u8 {
        LambdaModule::add_two_numbers(x, y)
    }

    public fun run_all() {
        let _ = LambdaModule::add_two_numbers(3u8, 4u8);
        let _ = LambdaModule::lambda_test(5u8, 6u8);
        let _ = LambdaModule::nested_lambda(7u8);
        let _ = call_inline_add(8u8, 9u8);
    }
}



//# run 0xCAFE::LambdaModule::add_two_numbers --args 5u8 8u8



//# run 0xCAFE::LambdaModule::lambda_test --args 2u8 3u8



//# run 0xCAFE::LambdaModule::nested_lambda --args 5u8



//# run 0xCAFE::CallerModule::call_inline_add --args 4u8 4u8



//# run 0xCAFE::CallerModule::run_all
