
//# publish
module 0xCAFE::Adder {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            42u8
        } else {
            0u8
        }
    }

    public fun run_lambda_expression(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::Adder::add_and_check --args 40u8 2u8


//# run 0xCAFE::Adder::add_and_check --args 10u8 5u8


//# run 0xCAFE::Adder::run_lambda_expression --args 5u8 6u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun nested_add(a: u8, b: u8, c: u8): u8 {
        let temp = Adder::add_and_check(a, b);
        // call again with the result plus c
        Adder::add_and_check(temp, c)
    }

    public fun runner() {
        let _ = nested_add(20u8, 22u8, 0u8);
        let _ = nested_add(1u8, 2u8, 39u8);
    }
}


//# run 0xCAFE::NestedCall::nested_add --args 20u8 22u8 0u8


//# run 0xCAFE::NestedCall::nested_add --args 1u8 2u8 39u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
