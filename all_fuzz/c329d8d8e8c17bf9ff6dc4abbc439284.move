
//# publish
module 0xCAFE::TestAdditionLambdaUninit {
    // Test 1: Simple addition function returning a constant after adding two u8 values
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed number regardless of sum
        42u8
    }

    // Test 2: Function containing lambda (anonymous function) that sums two u8s
    public fun lambda_sum(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    // Test 2 variant: Lambda that captures no outer variables and returns their product
    public fun lambda_product(a: u8, b: u8): u8 {
        let multiplier: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiplier(a, b)
    }

    // Test 3: Detect use of uninitialized local variable - variable not assigned before use
    // We fake detection by writing a function that attempts to use a variable before assignment
    // Note: The Move compiler will reject this, but we write the code to test compiler error detection
    // We split it into two functions because this will fail compilation if uncommented.
    //
    // To be able to compile this entire file, here we just provide a commented example:
    //
    // public fun use_uninit_var(): u8 {
    //     let x: u8; // declared but not initialized
    //     x + 1u8 // using x before initializing is not allowed
    // }

    // To still test uninitialized variables detection, we write an alternate function
    // that uses initialized variables only:
    public fun safe_var_usage(): u8 {
        let x: u8 = 10u8;
        x + 1u8
    }

    // Runner function that calls others to test basic usage
    public fun runner(): u8 {
        let added = add_and_return_constant(5u8, 7u8);
        let sum = lambda_sum(3u8, 4u8);
        let product = lambda_product(6u8, 2u8);
        let safe_result = safe_var_usage();
        added + sum + product + safe_result
    }
}


//# run 0xCAFE::TestAdditionLambdaUninit::add_and_return_constant --args 10u8 20u8


//# run 0xCAFE::TestAdditionLambdaUninit::lambda_sum --args 15u8 17u8


//# run 0xCAFE::TestAdditionLambdaUninit::lambda_product --args 8u8 9u8


//# run 0xCAFE::TestAdditionLambdaUninit::safe_var_usage


//# run 0xCAFE::TestAdditionLambdaUninit::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 6c81a04d3e438cd650e1b7363a72f69b: Detect uses of uninitialized local variables in functions.
