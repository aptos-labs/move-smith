
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun apply_lambda_double(x: u8): u8 {
        let multiply_by_two: |u8| u8 has copy+drop = |a: u8| a * 2;
        multiply_by_two(x)
    }

    public fun lambda_tuple(x: u8): (u8, u8) {
        let f: |u8| (u8, u8) has copy+drop = |a: u8| {
            (a + 1, a * 2)
        };
        f(x)
    }
}

 
//# run 0xCAFE::AddAndLambda::add_and_return --args 20u8 22u8
 
//# run 0xCAFE::AddAndLambda::apply_lambda_double --args 30u8
 
//# run 0xCAFE::AddAndLambda::lambda_tuple --args 50u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndLambda;

    // Removed inline keyword, made just public
    public fun inline_sum(a: u8, b: u8): u8 {
        AddAndLambda::add_and_return(a, b)
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let sum = inline_sum(a, b);
        AddAndLambda::apply_lambda_double(sum)
    }
}

 
//# run 0xCAFE::NestedCall::inline_sum --args 40u8 50u8
 
//# run 0xCAFE::NestedCall::nested_calls --args 10u8 15u8
