
//# publish
module 0xCAFE::MathAndLambda {
    use std::signer;

    // Simple function to add two u8 and then return a fixed u8 value.
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    // Function uses lambdas (anonymous functions).
    public fun lambda_usage(x: u8, y: u8): (u8, u8) {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let s = adder(x, y);
        let p = multiplier(x, y);
        (s, p)
    }

    // Inline function for use by another module.
    public inline fun inline_add(x: u16, y: u16): u16 {
        x + y
    }

    // Function uses match expression on u8.
    public fun match_example(value: u8): u8 {
        // FIX: The match construct is not valid in Move; replace with if-else chain.
        let result = if (value == 0) {
            100u8
        } else if (value == 1) {
            101u8
        } else if (value == 2) {
            102u8
        } else {
            255u8
        };
        result
    }
}



//# run 0xCAFE::MathAndLambda::add_then_return_fixed --args 10u8 20u8



//# run 0xCAFE::MathAndLambda::lambda_usage --args 6u8 7u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MathAndLambda;

    public fun call_inline(x: u16, y: u16): u16 {
        MathAndLambda::inline_add(x, y)
    }

    // Test a nested call, calling call_inline with arguments.
    public fun call_inline_no_args(): u16 {
        call_inline(100u16, 200u16)
    }

    public fun match_caller(value: u8): u8 {
        MathAndLambda::match_example(value)
    }
}



//# run 0xCAFE::InlineCaller::call_inline --args 15u16 25u16



//# run 0xCAFE::InlineCaller::call_inline_no_args



//# run 0xCAFE::InlineCaller::match_caller --args 0u8



//# run 0xCAFE::InlineCaller::match_caller --args 2u8



//# run 0xCAFE::InlineCaller::match_caller --args 42u8
