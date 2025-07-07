
//# publish
module 0xCAFE::AddAndLambda {
    use std::vector;

    // Simple function that adds two u8 and returns u8
    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    // Function with a lambda that doubles a number
    public fun call_lambda(x: u8): u8 {
        let double_lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2u8
        };
        double_lambda(x)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_values --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::call_lambda --args 21u8


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddAndLambda;

    // Inline function for triples a u8 value
    public inline fun triple(x: u8): u8 {
        x * 3u8
    }

    // Calls a function in another module and then also calls inline triple
    public fun combined_call(a: u8, b: u8): (u8, u8) {
        let sum = AddAndLambda::add_two_values(a, b);
        let triple_sum = triple(sum);
        (sum, triple_sum)
    }
}


//# run 0xCAFE::CallInline::combined_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
