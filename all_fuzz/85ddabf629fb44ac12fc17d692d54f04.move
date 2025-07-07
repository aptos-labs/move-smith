
//# publish
module 0xCAFE::Adder {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus 10
        sum + 10
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::Adder::add_then_return --args 5u8 7u8


//# run 0xCAFE::Adder::test_lambda --args 3u8 4u8



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public inline fun inline_add(a: u8): u8 {
        a + 1
    }

    public fun call_nested_inline(a: u8, b: u8): u8 {
        // Call the inline_add from the same module
        let intermediate = inline_add(a);
        // Call the add_then_return from Adder module to add intermediate and b
        Adder::add_then_return(intermediate, b)
    }
}


//# run 0xCAFE::Caller::call_nested_inline --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
