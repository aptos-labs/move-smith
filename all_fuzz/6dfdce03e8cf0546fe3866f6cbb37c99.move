
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun add_lambda(): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| x + y;
        lambda(10u8, 32u8)
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 5u8 10u8


//# run 0xCAFE::Adder::add_lambda


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        Adder::add_and_return_sum(a, b)
    }

    public fun call_add_lambda(): u8 {
        Adder::add_lambda()
    }
}


//# run 0xCAFE::Caller::call_add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::Caller::call_add_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
