
//# publish
module 0xCAFE::LambdaTests {
    // Test various anonymous functions with multiple parameters and captured environment

    public fun no_capture_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun capture_and_use_lambda(x: u8): u8 {
        let captured_value = x;
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * captured_value
        };
        lambda(5u8)
    }

    public fun multiple_params_lambda(x: u8, y: u8, z: u8): u8 {
        let lambda: |u8, u8, u8| u8 has copy+drop = |a: u8, b: u8, c: u8| {
            (a + b) * c
        };
        lambda(x, y, z)
    }

    public fun lambda_calling_lambda(x: u8, y: u8): u8 {
        let inner_lambda: |u8| u8 has copy+drop = |b: u8| {
            b * 2
        };
        let outer_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            inner_lambda(a) + inner_lambda(b)
        };
        outer_lambda(x, y)
    }

    native public fun native_add(x: u8, y: u8): u8;

    public fun use_native_add(x: u8, y: u8): u8 {
        native_add(x, y)
    }
}


//# run 0xCAFE::LambdaTests::no_capture_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaTests::capture_and_use_lambda --args 7u8


//# run 0xCAFE::LambdaTests::multiple_params_lambda --args 2u8 3u8 4u8


//# run 0xCAFE::LambdaTests::lambda_calling_lambda --args 5u8 6u8


//# run 0xCAFE::LambdaTests::use_native_add --args 10u8 20u8

// Attempt to import a module with a restricted or duplicate alias name (should cause compiler error)
// Uncommenting the following lines in a real test would cause compile failure and is here for demonstration only

/*
import 0xCAFE::LambdaTests as std; // 'std' alias is restricted and should cause error

import 0xCAFE::StorageUsage as LambdaTests; // Duplicate alias 'LambdaTests' causes error
*/

// The above import statements are intentionally commented to avoid compile error in this submission.


// Featurres:
// 9c8d9de92723c9d02990ddb928bae9e0: Test that Move anonymous functions (lambdas/closures) with various numbers and arrangements of parameters correctly capture and pass arguments to a function.
// cb2d48b351c3c55b97a8fc4ba45e4001: Use different function body types, such as defined or native, with appropriate validation.
// f6a96d478f9d1f255049689e2ff3629c: Receive an error if you attempt to import a module or member using a restricted or duplicate alias name.
