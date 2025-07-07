
//# publish
module 0xCAFE::Adder {
    public fun add_two_values_and_return_special_result(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return 42 if sum equals 42, else return sum
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun run_lambda_example(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            // Return product of x and y plus 1
            (x * y) + 1
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::Adder::add_two_values_and_return_special_result --args 20u8 22u8



//# run 0xCAFE::Adder::add_two_values_and_return_special_result --args 10u8 11u8



//# run 0xCAFE::Adder::run_lambda_example --args 3u8 4u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_adder_add_and_run_lambda(): (u8, u8) {
        let sum_result = Adder::add_two_values_and_return_special_result(30u8, 12u8);
        let lambda_result = Adder::run_lambda_example(5u8, 5u8);
        (sum_result, lambda_result)
    }
}



//# run 0xCAFE::NestedCall::call_adder_add_and_run_lambda
