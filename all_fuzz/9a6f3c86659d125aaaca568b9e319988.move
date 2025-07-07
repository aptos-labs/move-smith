
//# publish
module 0xCAFE::AddWithLambda {
    // This module tests addition of two u8 values and usage of lambda

    public fun add_two_values(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = add_two_values(x, y);
        sum + 1u8
    }
}


//# run 0xCAFE::AddWithLambda::add_two_values --args 5u8 10u8


//# run 0xCAFE::AddWithLambda::add_and_increment --args 5u8 10u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddWithLambda;

    public inline fun inline_double_add(x: u8, y: u8): u8 {
        let sum = AddWithLambda::add_two_values(x, y);
        sum + sum
    }

    public fun runner(): u8 {
        // Calling inline function and then add 1
        let doubled = inline_double_add(3u8, 4u8);
        doubled + 1u8
    }
}


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
