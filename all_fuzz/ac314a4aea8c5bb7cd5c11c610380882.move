
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returns sum + 10, for example
        sum + 10
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::Addition;

    public fun call_inline_adder(a: u8, b: u8): u8 {
        // Calls inline function from Addition module within another function
        Addition::inline_adder(a, b)
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let first = Addition::with_lambda(x, y);
        let second = call_inline_adder(x, y);
        first + second
    }
}


//# run 0xCAFE::Addition::add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::Addition::with_lambda --args 5u8 7u8


//# run 0xCAFE::CallerModule::call_inline_adder --args 15u8 25u8


//# run 0xCAFE::CallerModule::nested_calls --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
