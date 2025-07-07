
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_lambda_and_return(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_from_lambda(a: u8, b: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            0xCAFE::Adder::inline_add(x, y)
        };
        f(a, b)
    }

    public fun typed_params(a: u8, b: u8): u8 {
        add_and_return_sum(a, b)
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Adder::call_lambda_and_return --args 15u8 25u8


//# run 0xCAFE::Adder::call_inline_from_lambda --args 100u8 23u8


//# run 0xCAFE::Adder::typed_params --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 403dfff1858bc48a7d42d6798ba0fba3: Define function parameters with typed signatures
