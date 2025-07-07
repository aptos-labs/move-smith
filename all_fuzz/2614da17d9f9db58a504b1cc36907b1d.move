
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::ComputeAdd;

    public fun nested_call(x: u8, y: u8): u8 {
        let added = ComputeAdd::inline_add(x, y);
        ComputeAdd::add_then_return(added, 5u8)
    }

    public fun runner(): u8 {
        nested_call(2u8, 3u8)
    }
}


//# run 0xCAFE::ComputeAdd::add_then_return --args 7u8 4u8


//# run 0xCAFE::ComputeAdd::add_then_return --args 3u8 2u8


//# run 0xCAFE::ComputeAdd::with_lambda --args 5u8 8u8


//# run 0xCAFE::NestedCall::nested_call --args 2u8 3u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
