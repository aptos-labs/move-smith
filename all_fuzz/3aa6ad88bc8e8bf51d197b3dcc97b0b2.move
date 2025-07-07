
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}


//# run 0xCAFE::Adder::add_two_values --args 6u8 5u8


//# run 0xCAFE::Adder::add_two_values --args 3u8 4u8


//# run 0xCAFE::Adder::with_lambda --args 7u8 2u8


//# publish
module 0xCAFE::UseAdder {
    use 0xCAFE::Adder;

    public fun call_inline_addition(a: u8, b: u8): u8 {
        // call inside inline style function from Adder module
        Adder::add_two_values(a, b)
    }

    public fun call_lambda_addition(a: u8, b: u8): u8 {
        Adder::with_lambda(a, b)
    }

    public fun runner() {
        let _res1 = call_inline_addition(5u8, 6u8);
        let _res2 = call_lambda_addition(8u8, 1u8);
    }
}


//# run 0xCAFE::UseAdder::call_inline_addition --args 4u8 7u8


//# run 0xCAFE::UseAdder::call_lambda_addition --args 9u8 1u8


//# run 0xCAFE::UseAdder::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
