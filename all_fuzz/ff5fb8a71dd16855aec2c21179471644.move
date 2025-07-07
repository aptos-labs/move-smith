
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignored = sum;
        42u8
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::Adder::add_and_return_const --args 10u8 20u8


//# run 0xCAFE::Adder::add_with_lambda --args 5u8 7u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public inline fun inline_add_plus_one(a: u8, b: u8): u8 {
        // Call add_with_lambda from Adder and add 1 to the result
        let sum = Adder::add_with_lambda(a, b);
        sum + 1u8
    }

    public fun runner(): u8 {
        // Test nested call: inline function calling another module function
        let result = inline_add_plus_one(2u8, 3u8);
        result
    }
}


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
