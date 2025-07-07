
//# publish
module 0xCAFE::Computation {
    public fun add_then_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambda_example(x: u8): u8 {
        let l: |u8| u8 has copy+drop = |a: u8| {
            a + 5u8
        };
        l(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::LambdaAndCall {
    use 0xCAFE::Computation;

    public fun call_lambda_and_inline(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            sum
        };
        let res_lambda = lambda(x, y);
        let res_inline = Computation::inline_add(res_lambda, 1u8);
        res_inline
    }
}



//# publish
module 0xCAFE::UnaryAndLoops {
    public fun deref_and_unary(x_addr: &u8): u8 {
        let value = *x_addr;
        let incremented = value + 1u8;
        incremented
    }

    public fun while_with_nested_control(limit: u8): u8 {
        let counter = 0u8;
        while (counter < limit) {
            if (counter % 2u8 == 0) {
                counter = counter + 3u8;
            } else {
                counter = counter + 1u8;
            }
        };
        counter
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaAndCall;
    use 0xCAFE::UnaryAndLoops;

    public fun nested_test(x: u8, y: u8, ref_x: &u8, limit: u8): (u8, u8) {
        let call = LambdaAndCall::call_lambda_and_inline(x, y);
        let deref = UnaryAndLoops::deref_and_unary(ref_x);
        let loop_result = UnaryAndLoops::while_with_nested_control(limit);
        (call, loop_result)
    }
}



//# run 0xCAFE::Computation::add_then_return_specific --args 7u8 5u8



//# run 0xCAFE::Computation::lambda_example --args 10u8



//# run 0xCAFE::LambdaAndCall::call_lambda_and_inline --args 4u8 5u8



//# run 0xCAFE::UnaryAndLoops::deref_and_unary --args 1u8



//# run 0xCAFE::UnaryAndLoops::while_with_nested_control --args 10u8



//# run 0xCAFE::NestedCalls::nested_test --args 3u8 4u8 5u8 11u8
