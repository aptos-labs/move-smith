
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    // A simple function to test addition of two u8 values and return u8 + 10.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function with lambda (anonymous function) expressions returning sum and product as tuple.
    public fun lambda_operations(a: u8, b: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |x: u8, y:u8| {
            let s = x + y;
            let p = x * y;
            (s, p)
        };
        f(a, b)
    }

    // Inline function that returns a tuple of u64.
    public inline fun inline_sum_product(x: u64): (u64, u64) {
        (x + 1, x * 2)
    }

    // Call inline function defined here from inside another module FeatureCaller below
    public fun call_inline(x: u64): (u64, u64) {
        inline_sum_product(x)
    }

    // Iterator style function with dynamic termination conditions based on input parameter
    public fun dynamic_loop(limit: u8): u8 {
        let total = 0u8;
        let i = 0u8;
        while (i < limit) {
            total = total + i;
            // Condition to break dynamically
            if (total > 10) {
                break;
            };
            i = i + 1;
        };
        total
    }
}


//# run 0xCAFE::FeatureTest::add_and_offset --args 3u8 4u8


//# run 0xCAFE::FeatureTest::lambda_operations --args 5u8 6u8


//# run 0xCAFE::FeatureTest::dynamic_loop --args 255u8


//# publish
module 0xCAFE::FeatureCaller {
    use 0xCAFE::FeatureTest;

    // Test calling inside another module for nested inline function calls
    public fun test_inline_call(x: u64): (u64, u64) {
        FeatureTest::call_inline(x)
    }
}


//# run 0xCAFE::FeatureCaller::test_inline_call --args 7u64

// Pragma with multiple instructions in one line, testing parser
#pragma abigen, code_simplify, ast_simplify, code_elimination


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 823723e1def8777f084e943961db3477: Enable iteration over list elements with dynamic termination conditions based on custom logic.
// 983e72e07595dd99fc8b7b17b1cdb4e0: Include multiple pragma properties in a single pragma annotation to specify various compiler or verifier instructions.
// b39b2c5ecfe520bd28e7d0729b418906: Enable full AST (Abstract Syntax Tree) simplification and code elimination for Move programs.
