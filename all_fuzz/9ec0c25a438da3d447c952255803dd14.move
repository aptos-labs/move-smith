
//# publish
module 0xCAFE::AdderAndLambda {
    // Test 1: A simple addition of two u8 values and return a specific value
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + fixed offset 10u8
        sum + 10u8
    }

    // Test 2: A function that uses a lambda to multiply two u8 values, then add 5u8
    public fun lambda_multiply_add(a: u8, b: u8): u8 {
        // Inline Move does not support lambda expressions as closures or anonymous functions.
        // Instead, just write the logic inline.
        let product = a * b;
        product + 5u8
    }

    // Test 3: A function returning the input squared.
    public fun lambda_square(x: u8): u8 {
        // Again, inline the logic directly without lambda syntax
        x * x
    }
}



//# run 0xCAFE::AdderAndLambda::add_and_return_special --args 7u8 8u8



//# run 0xCAFE::AdderAndLambda::lambda_multiply_add --args 4u8 5u8



//# run 0xCAFE::AdderAndLambda::lambda_square --args 6u8


// publish AdderAndLambda module before CallInline module


//# publish
module 0xCAFE::CallInline {
    // no 'use' statement needed inside the same address or publish order matters
    // call fully qualified functions using module name

    public fun call_nested_functions(a: u8, b: u8): (u8, u8) {
        let sum_with_offset = 0xCAFE::AdderAndLambda::add_and_return_special(a, b);
        let square_a = 0xCAFE::AdderAndLambda::lambda_square(a);
        (sum_with_offset, square_a)
    }
}



//# run 0xCAFE::CallInline::call_nested_functions --args 3u8 7u8
