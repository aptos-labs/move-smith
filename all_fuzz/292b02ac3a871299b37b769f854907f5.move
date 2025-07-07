
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to test addition works and return value correctness
        sum + 10
    }

    public fun use_lambda_to_add(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::Adder::use_lambda_to_add --args 9u8 11u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Call inline function from Adder module
        let sum = Adder::inline_add(a, b);
        // Add 5 more to test nested arithmetic
        sum + 5
    }

    public fun runner(): u8 {
        call_inline_add(20, 22)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_add --args 13u8 14u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
