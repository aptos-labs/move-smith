
//# publish
module 0xCAFE::MathTest {
    use std::vector;

    // Simple struct to hold a pair of u8 values
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Function to add two u8 numbers and then return a constant u8 (testing addition and return)
    public fun add_and_return_constant(x: u8, y: u8): u8 {
        let sum = x + y;
        let constant = 42u8;
        // Use sum in some way so it isn't optimized away (just bind)
        let _dummy = sum;
        constant
    }

    // Function containing a lambda that multiplies and adds two u8 values and returns the result tuple
    public fun lambda_test(x: u8, y: u8): (u8, u8) {
        let multiply_add: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let prod = a * b;
            let added = a + b;
            (prod, added)
        };
        multiply_add(x, y)
    }

    // Inline function that calculates and returns sum and product of two u8 values
    public inline fun inline_sum_prod(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }

    // Data invariant function (expressed via assert) for Pair struct
    public fun check_invariant(pair: &Pair) {
        // Invariant: a must be less than b
        assert!(pair.a < pair.b, 1001);
    }

    // Runner function that internally packs the Pair and checks invariant 
    public fun runner() {
        let p = Pair {a: 5u8, b: 10u8};
        check_invariant(&p);
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathTest;
    use std::vector;

    // Calls the inline function from another module and returns sum only
    public fun call_inline_sum(x: u8, y: u8): u8 {
        let (sum, _prod) = MathTest::inline_sum_prod(x, y);
        sum
    }

    // Calls a function with lambda from MathTest and returns the product from the result tuple
    public fun call_lambda_test(x: u8, y: u8): u8 {
        let (prod, _add) = MathTest::lambda_test(x, y);
        prod
    }
}


//# run 0xCAFE::MathTest::add_and_return_constant --args 10u8 20u8


//# run 0xCAFE::MathTest::lambda_test --args 3u8 7u8


//# run 0xCAFE::MathTest::runner


//# run 0xCAFE::CallerModule::call_inline_sum --args 12u8 8u8


//# run 0xCAFE::CallerModule::call_lambda_test --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 70fc6b6d935c5f13469f3972e20d2441: Express data invariants within modules to enforce correctness constraints on data structures.
// bcb944831ff45a6adc5346b89680bf28: Ensure modules outside the `vector` dependency closure implicitly depend on the `vector` module for correct dependency ordering.
