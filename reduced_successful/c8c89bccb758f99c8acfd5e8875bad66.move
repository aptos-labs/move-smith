
//# publish
module 0xCAFE::AdditionModule {
    // A module to test basic addition

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum (not a fixed 42) to confirm addition done correctly
        sum
    }

    // Removed invalid lambda syntax because Move does not support lambdas

    // Instead, define a normal function that adds two u8s
    public fun add_lambda_fn(x: u8, y: u8): u8 {
        x + y
    }

    // A function calling the above 'lambda-replacement' function twice
    public fun add_lambda_copy(x: u8, y: u8): u8 {
        let add2 = add_lambda_fn;
        add2(x, y)
    }
}



//# run 0xCAFE::AdditionModule::add_two_u8 --args 5u8 7u8



//# run 0xCAFE::AdditionModule::add_lambda_fn --args 10u8 32u8



//# run 0xCAFE::AdditionModule::add_lambda_copy --args 5u8 6u8




//# publish
module 0xCAFE::NestedInlineModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let base = AdditionModule::add_two_u8(x, y);
        let inc = inline_increment(base);
        inc
    }
}



//# run 0xCAFE::NestedInlineModule::nested_call --args 1u8 2u8
