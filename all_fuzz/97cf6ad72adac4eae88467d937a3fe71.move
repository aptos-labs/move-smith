
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_five(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 5) {
            42u8
        } else {
            0u8
        }
    }

    public fun test_lambda() {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let _result = adder(2u8, 3u8);
    }
}


//# run 0xCAFE::TestAddition::add_and_return_five --args 2u8 3u8


//# run 0xCAFE::TestAddition::test_lambda



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::TestAddition;

    public inline fun inline_add_twice(a: u8, b: u8): u8 {
        let first_sum = TestAddition::add_and_return_five(a, b);
        let second_sum = TestAddition::add_and_return_five(first_sum, 0u8);
        second_sum
    }

    public fun call_inline_from_another_module(a: u8, b: u8): u8 {
        inline_add_twice(a, b)
    }
}


//# run 0xCAFE::NestedInlineCall::call_inline_from_another_module --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
