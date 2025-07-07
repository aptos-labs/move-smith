
//# publish
module 0xCAFE::Adder {
    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 100) {
            100u8
        } else {
            sum
        };
        result
    }

    public fun lambda_runner(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let res = add_one(x);
        res
    }

    public inline fun inline_double(a: u8): u8 {
        a * 2
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_inline_double(x: u8): u8 {
        let doubled = Adder::inline_double(x);
        doubled
    }

    public fun call_add_and_double(x: u8, y: u8): u8 {
        let sum = Adder::add_two(x, y);
        let doubled = call_inline_double(sum);
        doubled
    }
}


//# run 0xCAFE::Adder::add_two --args 40u8 50u8


//# run 0xCAFE::Adder::lambda_runner --args 10u8


//# run 0xCAFE::NestedCall::call_inline_double --args 20u8


//# run 0xCAFE::NestedCall::call_add_and_double --args 30u8 40u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
