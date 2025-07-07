
//# publish
module 0xCAFE::CalcAdd {
    public fun add_and_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return fixed value 42 regardless the sum
        42
    }

    public fun test_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 10u8
        };
        lambda(x)
    }
}


//# run 0xCAFE::CalcAdd::add_and_return_specific --args 7u8 8u8


//# run 0xCAFE::CalcAdd::test_lambda --args 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::CalcAdd;

    public inline fun inner_inline_function(a: u8): u8 {
        // Calls the add_and_return_specific function from CalcAdd
        let _ = CalcAdd::add_and_return_specific(3u8, 4u8);
        // Return a + 1
        a + 1u8
    }

    public fun runner(): u8 {
        let result = inner_inline_function(10u8);
        result
    }
}


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
