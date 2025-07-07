
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_and_return(x: u8, y: u8, return_value: u8): u8 {
        let sum = x + y;
        let _ = sum; // use sum to test computation
        return_value
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::ComputeAdd;

    public inline fun inline_add(a: u8, b: u8): u8 {
        ComputeAdd::add_and_return(a, b, a + b)
    }

    public fun call_inline() {
        let _res = inline_add(5u8, 7u8);
    }
}


//# run 0xCAFE::ComputeAdd::add_and_return --args 10u8 20u8 99u8


//# run 0xCAFE::ComputeAdd::lambda_add --args 15u8 25u8


//# run 0xCAFE::NestedCall::call_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
