
//# publish
module 0xCAFE::LambdaAndInline {
    // This module tests lambdas and inline functions

    // An inline function that doubles a u8 value
    public inline fun double(x: u8): u8 {
        x * 2
    }

    // A function that uses a lambda to increment a value by 3
    public fun lambda_increment(x: u8): u8 {
        let incrementer: |u8|u8 has copy+drop = |a: u8| {
            a + 3
        };
        incrementer(x)
    }

    public fun use_lambda_and_inline(x: u8): u8 {
        let inc = lambda_increment(x);
        let doubled = double(inc);
        doubled
    }
}


//# run 0xCAFE::LambdaAndInline::use_lambda_and_inline --args 10u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaAndInline;

    // Calls inline function `double` in LambdaAndInline module
    public fun call_double(x: u8): u8 {
        LambdaAndInline::double(x)
    }

    // Calls use_lambda_and_inline in LambdaAndInline module and returns its result plus 1
    public fun call_use_lambda_and_inline(x: u8): u8 {
        let nested_result = LambdaAndInline::use_lambda_and_inline(x);
        nested_result + 1
    }
}


//# run 0xCAFE::InlineCaller::call_double --args 15u8


//# run 0xCAFE::InlineCaller::call_use_lambda_and_inline --args 7u8


//# publish
module 0xCAFE::ForeachTest {
    use std::vector;

    // Takes a vector of u8 and returns the sum of all elements using foreach style iteration with loop
    public fun sum_vector(v: vector<u8>): u64 {
        let sum = 0u64;
        for (i in 0..vector::length(&v)) {
            let val = *vector::borrow(&v, i);
            sum = sum + (val as u64);
        };
        sum
    }

    // A runner function that creates a vector and calls sum_vector and returns the result
    public fun runner(): u64 {
        let v = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        sum_vector(v)
    }
}


//# run 0xCAFE::ForeachTest::runner


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6429218e3e29ce1b963e2bcaa3f3a253: Test that the `foreach` function correctly iterates over a vector and computes the sum of its elements.
