
//# publish
module 0xCAFE::MyModule {
    // Defining inline function f2 that takes a u16 and returns (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//// Move requires modules to be declared before they are used, so MyModule must come before LambdaAndInline


//# publish
module 0xCAFE::LambdaAndInline {
    // Removed unused import `std::signer`

    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x * y };
        let result = f(a, b);
        result
    }

    public fun call_inline_from_other_module(a: u16): (u16, u16) {
        // Call the inline function f2 from MyModule that returns a tuple
        0xCAFE::MyModule::f2(a)
    }

    public fun sequence_expression_example(a: u8): u8 {
        let r = {
            let t = a * 2;
            let t2 = t + 3;
            t2 - 1
        };
        r
    }

    // lint_skip(type_check)]
    public fun suppress_lint_example() {
        // This function intentionally left blank to test lint skip attribute
    }
}

//
//# run 0xCAFE::LambdaAndInline::add_two_u8_values --args 4u8 7u8

//
//# run 0xCAFE::LambdaAndInline::lambda_example --args 3u8 5u8

//
//# run 0xCAFE::LambdaAndInline::call_inline_from_other_module --args 20u16

//
//# run 0xCAFE::LambdaAndInline::sequence_expression_example --args 4u8

//
//# run 0xCAFE::LambdaAndInline::suppress_lint_example
