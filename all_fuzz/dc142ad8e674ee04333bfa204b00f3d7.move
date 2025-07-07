
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // After computing sum, return a fixed value 42
        42
    }

    public fun with_lambda(x: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let y = 10u8;
        add_lambda(x, y)
    }
}


//# run 0xCAFE::Adder::add_and_return_fixed --args 5u8 7u8


//# run 0xCAFE::Adder::with_lambda --args 32u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public inline fun inline_add(a: u8, b:u8): u8 {
        a + b
    }

    public fun outer_call(a: u8, b: u8): u8 {
        let inner_result = inline_add(a, b);
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            Adder::add_and_return_fixed(inner_result, x)
        };
        lambda(1u8)
    }
}


//# run 0xCAFE::NestedCall::outer_call --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
