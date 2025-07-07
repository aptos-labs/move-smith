
//# publish
module 0xCAFE::MathUtils {
    // Utility module to test inline functions and lambdas

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun use_lambda_sum(x: u8, y: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = sum_lambda(x, y);
        sum
    }

    public fun runner(): u8 {
        let a = 5u8;
        let b = 7u8;

        // This should return 12
        let sum1 = add_u8(a, b);

        // This tests assignment after initialization and mutation
        let mut_value = sum1;
        let mut_value_updated = mut_value + 1;

        let sum2 = use_lambda_sum(a, b);

        // Last expression is the result of sum1 + sum2 + mut_value_updated
        sum1 + sum2 + mut_value_updated
    }
}


//# run 0xCAFE::MathUtils::runner


//# publish
module 0xCAFE::ExternalCall {
    use 0xCAFE::MathUtils;

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        // Call inline add_u8 function from MathUtils
        let sum = MathUtils::add_u8(x, y);

        // Call the lambda-using function
        let lambda_sum = MathUtils::use_lambda_sum(x, y);

        sum + lambda_sum
    }

    public fun test_assignments() {
        let a = 10u8;
        let b = 20u8;
        let mut_a = a;
        let mut_b = b;

        // Re-assign variables (assignments)
        let new_a = mut_a + 5;
        let new_b = mut_b + 6;

        let total = new_a + new_b;

        // Suppress unused variable warning by final expression
        total;
    }

    public fun runner(): u8 {
        call_inline_and_lambda(8u8, 9u8)
    }
}


//# run 0xCAFE::ExternalCall::runner


//# publish
module 0xCAFE::VerifierTests {
    // This module contains unused functions to test duplicate attribute prevention and bytecode verifier mismatch.
    // We deliberately do not attach duplicate attributes.

    // Test function with valid bytecode pattern
    public fun simple_addition(a: u8, b: u8): u8 {
        a + b
    }

    // Deliberately unused function, no duplicate attributes attached.
    public fun unused_function() {
        let _x = 1u8;
    }
}


//# run 0xCAFE::VerifierTests::simple_addition --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2ef22ecb555173602992353c09135357: Detect assignments to variables and mark them as possibly modified.
// fefd36857fb737b210012bc5a2b3b39d: Trigger compiler diagnostics when bytecode verifier mismatches occur in user code
// 2b6bfcc30072353846ac0500ff65e4a8: Avoid attaching duplicate attributes with the same name to a single item.
