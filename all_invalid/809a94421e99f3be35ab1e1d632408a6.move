
//# publish
module 0xCAFE::TestLambdas {
    use std::vector;

    // Step 1: Lifted functions from lambdas used in the test
    public fun lambda_callback_0(a: u8, b: u8): (u8, u8) {
        let c = a + b;
        let d = a * b;
        (c, d)
    }

    public fun lambda_callback_1(a: u8, b: u8, inner: |u8, u8| (u8, u8)): (u8, u8) {
        // Call inner lambda
        inner(a, b)
    }

    // Additional lambda transform with nested call
    public fun lambda_callback_2(x: u8): (u8, u8) {
        // Reuse lambda_callback_0 logic inline
        let (c, d) = lambda_callback_0(x, x);
        (c, d)
    }

    // Main test function that takes lambdas as parameters
    public fun run_test(
        lambda0: |u8, u8| (u8, u8),
        lambda1: |u8, u8, |u8, u8| (u8, u8)| (u8, u8)
    ) {
        // Call lambda0
        let _res0 = lambda0(2, 3);
        // Call lambda1 with an inline lambda as argument
        let _res1 = lambda1(4, 5, lambda_callback_0);
        // Call nested lambda
        let _res2 = lambda1(6, 7, lambda_callback_2);
        // Return unit
        ()
    }

    // A wrapper function to call the main test function with specific lambdas
    public fun run_covariant() {
        run_test(lambda_callback_0, lambda_callback_1);
    }
}



//# run 0xCAFE::TestLambdas::run_covariant --signers 0xBEEF


// Featurres:
// 23bf4dac0b49aa979852f3fbacf7cb8b: Use lambda lifting to transform lambda expressions into top-level functions.
// 692a8477b375dc6229cbf28d9917e838: Allow lambda parameters in spec functions; these parameters will be symbolized and tracked for use in expanded expressions.
// 8c738cf5e5ee14fc926782c3f0f6d187: Test that lambda expressions (function values) can be passed as arguments to public entry functions, including using lambdas that call other lambdas as arguments.