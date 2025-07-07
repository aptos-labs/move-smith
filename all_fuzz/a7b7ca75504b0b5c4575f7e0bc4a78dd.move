
//# publish
module 0xCAFE::Addition {
    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 42u8;
        result
    }

    public fun lambda_add_mul(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::Addition::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::Addition::lambda_add_mul --args 3u8 4u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Addition;

    public fun call_inline_add(x: u8, y: u8): u8 {
        // Calls Addition::add_two_u8 to get result
        Addition::add_two_u8(x, y)
    }

    public fun runner() {
        let _res1 = call_inline_add(5u8, 7u8);
        let (_add, _mul) = Addition::lambda_add_mul(2u8, 8u8);
    }
}


//# run 0xCAFE::Caller::call_inline_add --args 12u8 13u8


//# run 0xCAFE::Caller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
