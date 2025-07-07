
//# publish
module 0xCAFE::MathModule {
    // A module to test addition and lambda expressions

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        };
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(a, b);
        result
    }

    public fun use_inline_and_lambda(x: u16, a: u8, b: u8): (u16, u8) {
        let (inc1, inc2) = Self::inline_increment(x);
        let add_lambda: |u8, u8| u8 has copy+drop = |m: u8, n: u8| {
            m + n
        };
        let sum = add_lambda(a, b);
        (inc1 + inc2, sum)
    }

    public inline fun inline_increment(a: u16): (u16, u16) {
        // Just add 1 and 2 as example
        (a + 1, a + 2)
    }
}




//# run 0xCAFE::MathModule::add_two_values --args 6u8 5u8




//# run 0xCAFE::MathModule::use_lambda --args 7u8 8u8




//# run 0xCAFE::MathModule::use_inline_and_lambda --args 10u16 4u8 3u8





//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_inline_and_lambda(x: u16, a: u8, b: u8): u8 {
        // Calls inline function in MathModule and uses lambda return from there
        let (inc1, inc2) = MathModule::inline_increment(x);
        let add_lambda: |u8, u8| u8 has copy+drop = |m: u8, n: u8| {
            m + n
        };
        let sum_lambda = add_lambda(a, b);
        let sum_total = ((inc1 + inc2) as u8) + sum_lambda;
        sum_total
    }
}




//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 20u16 1u8 2u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
