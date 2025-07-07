
//# publish
module 0xCAFE::Adder {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10
        } else {
            sum
        }
    }

    public fun test_lambda_usage(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }
}


//# run 0xCAFE::Adder::add_two_u8 --args 4u8 5u8


//# run 0xCAFE::Adder::add_two_u8 --args 7u8 8u8


//# run 0xCAFE::Adder::test_lambda_usage --args 3u8 4u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_inline_increment_twice(a: u8): u8 {
        let first = Adder::inline_increment(a);
        let second = Adder::inline_increment(first);
        second
    }
}


//# run 0xCAFE::NestedCall::call_inline_increment_twice --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
