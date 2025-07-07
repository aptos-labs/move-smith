
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun get_lambda() : |u8, u8|u8 {
        let lambda = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}


//# run 0xCAFE::Adder::add_two_values --args 3u8 4u8


//# run 0xCAFE::Adder::add_two_values --args 7u8 7u8


//# run 0xCAFE::Adder::get_lambda


//# publish
module 0xCAFE::LambdaUser {
    use 0xCAFE::Adder;

    public fun use_lambda(): u8 {
        let lambda = Adder::get_lambda();
        let result = lambda(2u8, 3u8);
        result
    }

    public inline fun inline_call(x: u8): (u8, u8) {
        let (a, b) = (x + 1, x + 2);
        (a, b)
    }

    public fun nested_calls(x: u8): u8 {
        let (a, b) = inline_call(x);
        let sum = a + b + x;
        sum
    }
}


//# run 0xCAFE::LambdaUser::use_lambda


//# run 0xCAFE::LambdaUser::nested_calls --args 5u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::LambdaUser;

    public fun call_nested(x: u8): u8 {
        LambdaUser::nested_calls(x)
    }
}


//# run 0xCAFE::NestedCaller::call_nested --args 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 74454629fd6094069b32ea18cde73d14: Analyze dependency graphs to identify minimal cycles in module references
