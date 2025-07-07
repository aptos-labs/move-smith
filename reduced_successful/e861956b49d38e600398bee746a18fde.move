
//# publish
module 0xCAFE::MathModule {
    // This module tests addition function and lambda expressions

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100
        } else {
            sum
        }
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun with_complex_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |val: u8| {
            if (val > 5) {
                val * 2
            } else {
                val + 3
            }
        };
        lambda(x)
    }
}


//# run 0xCAFE::MathModule::add_two_u8 --args 40u8 50u8


//# run 0xCAFE::MathModule::with_lambda --args 7u8 8u8


//# run 0xCAFE::MathModule::with_complex_lambda --args 6u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_add(a: u8, b: u8): u8 {
        // Call function from MathModule
        MathModule::add_two_u8(a, b)
    }

    public fun call_with_lambda(a: u8, b: u8): u8 {
        MathModule::with_lambda(a, b)
    }

    public fun call_with_complex_lambda(x: u8): u8 {
        MathModule::with_complex_lambda(x)
    }
}


//# run 0xCAFE::CallerModule::call_add --args 20u8 30u8


//# run 0xCAFE::CallerModule::call_with_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_with_complex_lambda --args 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
