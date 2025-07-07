
//# publish
module 0xCAFE::AddAndLambda {
    // Removed unused import: std::vector

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun run_lambda_operations(x: u8, y: u8): (u8, u8) {
        let lambda_add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let lambda_mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        (lambda_add(x, y), lambda_mul(x, y))
    }
}



//# run 0xCAFE::AddAndLambda::add_two_values --args 7u8 8u8



//# run 0xCAFE::AddAndLambda::run_lambda_operations --args 3u8 4u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndLambda;

    public fun call_add_two_values(x: u8, y: u8): u8 {
        AddAndLambda::add_two_values(x, y)
    }

    public fun call_run_lambda_operations(x: u8, y: u8): (u8, u8) {
        AddAndLambda::run_lambda_operations(x, y)
    }
}



//# run 0xCAFE::CallerModule::call_add_two_values --args 5u8 6u8



//# run 0xCAFE::CallerModule::call_run_lambda_operations --args 2u8 3u8
