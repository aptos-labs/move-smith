
//# publish
module 0xCAFE::Calc {
    // Module to test addition and lambdas

    public fun add_two_u8_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun apply_lambda_and_return_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun nested_lambda_example(): u8 {
        let outer_lambda: |u8| u8 has copy+drop = |x: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |y: u8| { y + 1u8 };
            inner_lambda(x) + 1u8
        };
        outer_lambda(3u8)
    }
}



//# run 0xCAFE::Calc::add_two_u8_and_return_specific_value --args 4u8 5u8



//# run 0xCAFE::Calc::add_two_u8_and_return_specific_value --args 7u8 5u8



//# run 0xCAFE::Calc::apply_lambda_and_return_sum --args 10u8 15u8



//# run 0xCAFE::Calc::nested_lambda_example




//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun call_calc_add(a: u8, b: u8): u8 {
        Calc::add_two_u8_and_return_specific_value(a, b)
    }

    public fun call_calc_lambda(a: u8, b: u8): u8 {
        Calc::apply_lambda_and_return_sum(a, b)
    }

    public fun call_calc_nested(): u8 {
        Calc::nested_lambda_example()
    }
}



//# run 0xCAFE::Caller::call_calc_add --args 2u8 3u8



//# run 0xCAFE::Caller::call_calc_lambda --args 6u8 7u8



//# run 0xCAFE::Caller::call_calc_nested
