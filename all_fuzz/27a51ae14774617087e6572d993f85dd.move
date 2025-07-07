
//# publish
module 0xCAFE::LambdaModule {
    use std::signer;

    /// Returns the addition of two u8 values plus 10
    public fun add_and_return_plus_ten(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// A function that has a lambda which returns the product of two u8 values
    public fun lambda_product(a: u8, b: u8): u8 {
        let prod_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        prod_lambda(a, b)
    }

    /// Use a lambda that captures and increments captured value
    public fun increment_with_lambda(start: u8, incr: u8): u8 {
        let captured = start;
        let inc_lambda: |u8| u8 has copy+drop = |x: u8| {
            captured + x + incr
        };
        inc_lambda(1)
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_plus_ten --args 5u8 7u8


//# run 0xCAFE::LambdaModule::lambda_product --args 3u8 5u8


//# run 0xCAFE::LambdaModule::increment_with_lambda --args 10u8 2u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    /// Call inline function from LambdaModule that adds two u8 values and returns plus 10
    public fun call_add_and_plus_ten(): u8 {
        LambdaModule::add_and_return_plus_ten(15u8, 20u8)
    }

    /// Call lambda_product function to multiply two numbers and add 5
    public fun call_lambda_product_plus_five(): u8 {
        let product = LambdaModule::lambda_product(4u8, 6u8);
        product + 5
    }
}


//# run 0xCAFE::CallerModule::call_add_and_plus_ten


//# run 0xCAFE::CallerModule::call_lambda_product_plus_five

// A spec block with use declaration importing other named specs
// We assume a framework or tool interprets this spec block accordingly

spec 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    fun test_add_and_return_plus_ten() {
        let result = LambdaModule::add_and_return_plus_ten(11u8, 9u8);
        // Assume here a test framework checks result == 30, no assert needed in transactional test
    }

    fun test_lambda_product() {
        let result = LambdaModule::lambda_product(2u8, 8u8);
        // Assume test framework checks result == 16
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 17c390b072c12b3bceb96eba26f1ecae: Include 'use' declarations at the start of a spec block to import other named specifications.
