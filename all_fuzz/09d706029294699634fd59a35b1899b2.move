
//# publish
module 0xCAFE::AddLambda {
    // Test addition of two u8 values and return u8 result
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // Function containing a lambda expression that doubles a u8 value
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |v: u8| {
            v + v
        };
        doubler(x)
    }

    // Inline function to increment a u16 value
    public inline fun increment_u16(val: u16): u16 {
        val + 1
    }
}


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::AddLambda;

    // Call inline function from AddLambda module, add 10 to the result and return u16
    public fun call_increment_and_add(x: u16): u16 {
        let incremented = AddLambda::increment_u16(x);
        incremented + 10
    }
}


//# run 0xCAFE::AddLambda::add_two_values --args 13u8 29u8


//# run 0xCAFE::AddLambda::double_with_lambda --args 15u8


//# run 0xCAFE::InlineCall::call_increment_and_add --args 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
