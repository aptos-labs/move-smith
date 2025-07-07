
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value regardless of sum
        42u8
    }

    public fun test_lambda_add() {
        let add = |x: u8, y: u8| {
            x + y
        };
        let _result = add(4u8, 5u8);
    }

    public fun call_inline_adder(x: u8, y: u8): u8 {
        inline_fun(x, y)
    }

    public inline fun inline_fun(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::Adder::add_and_return_fixed --args 7u8 8u8


//# run 0xCAFE::Adder::test_lambda_add


//# run 0xCAFE::Adder::call_inline_adder --args 12u8 13u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun nested_call(x: u8, y: u8): u8 {
        let intermediate = Adder::inline_fun(x, y);
        let final_res = Adder::add_and_return_fixed(x, intermediate);
        final_res
    }
}


//# run 0xCAFE::Caller::nested_call --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
