
//# publish
module 0xCAFE::Adder {
    public fun add_then_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed special value regardless of sum, e.g., 42
        42u8
    }

    public fun use_lambda_to_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_add_then_return_special(a: u8, b: u8): u8 {
        Adder::add_then_return_special(a, b)
    }

    public fun call_use_lambda_to_add(a: u8, b: u8): u8 {
        Adder::use_lambda_to_add(a, b)
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Calls inline function from Adder, should return a+b
        Adder::inline_add(a, b)
    }
}


//# run 0xCAFE::Adder::add_then_return_special --args 10u8 20u8


//# run 0xCAFE::Adder::use_lambda_to_add --args 15u8 25u8


//# run 0xCAFE::Caller::call_add_then_return_special --args 5u8 7u8


//# run 0xCAFE::Caller::call_use_lambda_to_add --args 6u8 9u8


//# run 0xCAFE::Caller::call_inline_add --args 12u8 18u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
