
//# publish
module 0xCAFE::NestedInline {
    public inline fun add_one(a: u8): u8 {
        a + 1
    }

    public inline fun add_two(a: u8): u8 {
        let b = add_one(a);
        b + 1
    }
}




//# publish
module 0xCAFE::LambdaFunctions {
    public fun test_lambda_addition(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let result = add(x, y);
        result
    }

    public fun test_lambda_return_lambda(x: u8): u8 {
        // Move does NOT support defining functions inside functions.
        // So instead of trying to define an inner function, do the logic inline.

        x + 5u8
    }
}




//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::NestedInline;

    public fun call_nested(a: u8): u8 {
        NestedInline::add_two(a)
    }
}




//# run 0xCAFE::LambdaFunctions::test_lambda_addition --args 10u8 20u8




//# run 0xCAFE::LambdaFunctions::test_lambda_return_lambda --args 7u8




//# run 0xCAFE::CrossModuleCall::call_nested --args 8u8
