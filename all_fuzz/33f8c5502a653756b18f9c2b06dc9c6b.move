
//# publish
module 0xCAFE::Calc {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let add_mul: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let m = a * b;
            (s, m)
        };
        add_mul(x, y)
    }

    public inline fun inline_sum(a: u16, b: u16): u16 {
        a + b
    }
}


//# run 0xCAFE::Calc::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::Calc::use_lambda --args 3u8 5u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calc;

    public fun call_inline_and_add(x: u16, y: u16, z: u8): u16 {
        let sum = Calc::inline_sum(x, y);
        // Convert z to u16 for addition
        (sum + (z as u16))
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_add --args 10u16 20u16 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
