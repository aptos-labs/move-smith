// Fixed transactional test code


//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_increment(x: u8): u8 {
        let inc: |u8|u8 has copy+drop = |n: u8| { n + 1 };
        inc(x)
    }

    public fun lambda_double_then_add(x: u8, y: u8): u8 {
        let double: |u8|u8 has copy+drop = |n: u8| { n * 2 };
        let result = double(x) + y;
        result
    }
}



//# run 0xCAFE::Adder::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::Adder::lambda_increment --args 100u8


//# run 0xCAFE::Adder::lambda_double_then_add --args 5u8 3u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Adder;

    // remove `inline` keyword to fix FUNCTION_RESOLUTION_FAILURE on calls to functions with closures

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        Adder::add_and_return_sum(a, b)
    }

    public fun call_lambda_increment(x: u8): u8 {
        Adder::lambda_increment(x)
    }

    public fun call_lambda_double_then_add(x: u8, y: u8): u8 {
        Adder::lambda_double_then_add(x, y)
    }

    public fun runner_no_args(): u8 {
        call_add_and_return_sum(7u8, 8u8)
    }
}



//# run 0xCAFE::InlineCaller::call_add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::InlineCaller::call_lambda_increment --args 200u8


//# run 0xCAFE::InlineCaller::call_lambda_double_then_add --args 4u8 1u8


//# run 0xCAFE::InlineCaller::runner_no_args
