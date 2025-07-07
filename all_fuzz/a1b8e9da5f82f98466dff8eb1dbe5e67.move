
//# publish
module 0xCAFE::LambdaAdd {
    // This module tests addition of two u8 values and lambdas.
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to get a distinct result to test correctness
        sum + 10
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            // Return a + b
            a + b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::LambdaAdd::add_two_values --args 7u8 9u8



//# run 0xCAFE::LambdaAdd::apply_lambda --args 8u8 12u8


// Fix here: removed `inline` keyword from the function, which caused the FUNCTION_RESOLUTION_FAILURE in the NestedCall module


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaAdd;

    // Removed `inline` keyword from this function.
    public fun call_add_and_apply(x: u8, y: u8): u8 {
        let interm = LambdaAdd::add_two_values(x, y);
        let result = LambdaAdd::apply_lambda(interm, 1u8);
        result
    }

    public fun runner(): u8 {
        call_add_and_apply(3u8, 4u8)
    }
}



//# run 0xCAFE::NestedCall::call_add_and_apply --args 5u8 6u8



//# run 0xCAFE::NestedCall::runner
