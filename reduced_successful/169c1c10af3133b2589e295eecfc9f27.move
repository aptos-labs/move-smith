
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8, return_val: u8): u8 {
        let sum = a + b;
        let _dummy = sum; // use sum to test addition
        return_val
    }
}



//# run 0xCAFE::AddAndReturn::add_and_return --args 3u8 4u8 42u8



//# publish
module 0xCAFE::LambdaTests {
    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun call_lambda_return_tuple(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + 1, b + 1)
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::LambdaTests::call_lambda --args 5u8 6u8



//# run 0xCAFE::LambdaTests::call_lambda_return_tuple --args 7u8 8u8



//# publish
module 0xCAFE::CrossCall {
    use 0xCAFE::AddAndReturn;
    use 0xCAFE::LambdaTests;

    public fun nested_call(x: u8, y: u8): (u8, u8) {
        let val = AddAndReturn::add_and_return(x, y, 99u8);
        let (a, b) = LambdaTests::call_lambda_return_tuple(x, y);
        (val, a + b)
    }
}



//# run 0xCAFE::CrossCall::nested_call --args 10u8 20u8



//# publish
module 0xCAFE::ExpressionMix {
    public fun unary_binary_mix(x: u8): u8 {
        // Mix unary and binary expressions in one statement
        let y = !false;
        let z = x + (if (y) { 1 } else { 0 });
        z
    }
}



//# run 0xCAFE::ExpressionMix::unary_binary_mix --args 5u8
