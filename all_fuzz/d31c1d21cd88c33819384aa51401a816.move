
//# publish
module 0xCAFE::Adder {
    // Simple module to test addition and return a fixed value

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let c = a + b;
        // Return a fixed value to test control flow return
        42u8
    }

    public fun with_lambda_example(): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = f(10u8, 15u8);
        // Return sum plus fixed offset
        sum + 5u8
    }
}


//# run 0xCAFE::Adder::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::Adder::with_lambda_example



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    // Call inline function from Adder module that tests nested call and inline fn

    public inline fun inline_adder_call(x: u8, y: u8): (u8, u8) {
        // Call an inline function that returns a tuple (simulate nested calls)
        Adder::with_lambda_example() as u8;
        (x + y, x * y)
    }

    public fun nested_calls_test(x: u8, y: u8): u8 {
        let (sum, _product) = inline_adder_call(x, y);
        // use sum from inline_adder_call and add some number
        sum + 1u8
    }
}


//# run 0xCAFE::Caller::nested_calls_test --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
