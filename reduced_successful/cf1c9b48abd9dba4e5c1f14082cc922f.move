
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    const CONST_VAL: u8 = 42;

    // derive(Store)]
    struct AnnotatedStruct has store {
        // const_attr = 100]
        value: u8,
    }

    // const_attr = 0xCAFE::AddAndLambda::CONST_VAL]
    const CONST_ATTR_TEST: u8 = 10;

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // return CONST_VAL when sum equals a predefined value to test constant and return
        if (sum == 10) {
            CONST_VAL
        } else {
            sum
        }
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun run_higher_order_lambda(x: u8): u8 {
        let apply = |f: |u8| u8, val: u8| {
            f(val)
        };

        let double = |n: u8| {
            n * 2
        };

        apply(double, x)
    }

    // inline(always)]
    public fun runner_no_args(): u8 {
        let a = 3u8;
        let b = 7u8;
        let res = add_two_values(a, b);
        let lambda_res = run_lambda_example(a, b);
        let hof_res = run_higher_order_lambda(5u8);
        res + lambda_res + hof_res
    }
}



//# run 0xCAFE::AddAndLambda::add_two_values --args 4u8 6u8



//# run 0xCAFE::AddAndLambda::add_two_values --args 3u8 7u8



//# run 0xCAFE::AddAndLambda::run_lambda_example --args 15u8 5u8



//# run 0xCAFE::AddAndLambda::run_higher_order_lambda --args 10u8



//# run 0xCAFE::AddAndLambda::runner_no_args
