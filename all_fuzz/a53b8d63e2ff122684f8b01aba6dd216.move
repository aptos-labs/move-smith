
//# publish
module 0xCAFE::Addition {
    // Simple addition module

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10
        sum + 10
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(x, y);
        // return result * 2
        result * 2
    }
}


//# run 0xCAFE::Addition::add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::Addition::with_lambda --args 10u8 15u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Addition;

    public inline fun inline_add_increase(a: u8, b: u8): u8 {
        // Calls Addition::add_and_return_sum internally and adds 5
        let intermediate = Addition::add_and_return_sum(a, b);
        intermediate + 5
    }

    public fun call_inline_fun(a: u8, b: u8): u8 {
        inline_add_increase(a, b)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_fun --args 30u8 40u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
