
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddAndReturn::add_then_return --args 5u8 7u8


//# run 0xCAFE::AddAndReturn::test_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturn;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let sum = AddAndReturn::inline_add(x, y);
        sum + 1u8
    }

    public fun runner() {
        let _ = call_inline_and_add(10u8, 20u8);
        let _ = AddAndReturn::add_then_return(8u8, 12u8);
        let _ = AddAndReturn::test_lambda(2u8, 3u8);
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_add --args 10u8 20u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
