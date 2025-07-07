
//# publish
module 0xCAFE::AddAndLambda {
    // Test 1: Function that adds two u8 and returns (sum + 5)
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5u8
    }

    // Test 2: Function containing lambda (anonymous function) expressions
    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |p: u8, q: u8| { p + q };
        let multiplier: |u8, u8| u8 has copy+drop = |p: u8, q: u8| { p * q };
        let sum = adder(x, y);
        let product = multiplier(x, y);
        sum + product
    }
}


//# run 0xCAFE::AddAndLambda::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 5u8 6u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndLambda;

    // Test 3: Call inline function from another module and perform nested function calls
    // define own inline function
    public inline fun inline_increment(a: u8): u8 {
        a + 1u8
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        // Call external module function which returns sum + 5
        let sum_offset = AddAndLambda::add_and_offset(x, y);

        // Call own inline increment function on result
        let incremented = inline_increment(sum_offset);

        incremented
    }
}


//# run 0xCAFE::InlineCaller::call_nested_functions --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
