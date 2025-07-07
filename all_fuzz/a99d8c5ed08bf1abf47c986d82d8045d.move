
//# publish
module 0xCAFE::Adder {
    // Simple function to add two u8 values and then add 1 more and return the result
    public fun add_and_inc(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function using lambda (anonymous function) to multiply two u8 numbers
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let mul: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        mul(a, b)
    }

    // Function that returns a lambda which adds 10 to its input
    public fun make_add_10_lambda(): |u8| u8 has copy+drop {
        let adder: |u8| u8 has copy+drop = |x: u8| { x + 10 };
        adder
    }

    // Runner function that calls add_and_inc and multiply_lambda
    public fun runner() {
        let x = Self::add_and_inc(3u8, 4u8);
        let y = Self::multiply_lambda(5u8, 6u8);
        let add10 = Self::make_add_10_lambda();
        let _z = add10(7u8);
    }
}


//# run 0xCAFE::Adder::add_and_inc --args 5u8 7u8


//# run 0xCAFE::Adder::multiply_lambda --args 3u8 4u8


//# run 0xCAFE::Adder::make_add_10_lambda


//# run 0xCAFE::Adder::runner


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    // Call the inline add_and_inc function from Adder
    public fun call_inline_add_and_inc(a: u8, b: u8): u8 {
        Adder::add_and_inc(a, b)
    }

    // Call multiply_lambda from Adder
    public fun call_multiply_lambda(a: u8, b: u8): u8 {
        Adder::multiply_lambda(a, b)
    }

    // Call the runner function of Adder which involves lambdas and adds
    public fun call_runner() {
        Adder::runner();
    }
}


//# run 0xCAFE::Caller::call_inline_add_and_inc --args 10u8 20u8


//# run 0xCAFE::Caller::call_multiply_lambda --args 7u8 8u8


//# run 0xCAFE::Caller::call_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
