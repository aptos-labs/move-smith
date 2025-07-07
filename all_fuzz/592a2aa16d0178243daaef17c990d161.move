
//# publish
module 0xCAFE::Calc {
    // Module to test addition and lambda expressions

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returning a fixed u8 value 42 after addition to test logic.
        42
    }

    public fun apply_lambda(x: u8): u8 {
        let increment: |u8|u8 has copy+drop = |v: u8| {
            v + 1
        };
        increment(x)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun call_add() {
        let _res = Calc::add_two_u8(10u8, 20u8);
    }

    public fun call_lambda() {
        let _res = Calc::apply_lambda(41u8);
    }

    public fun call_inline_double(x: u8): u8 {
        Calc::inline_double(x)
    }
}


//# run 0xCAFE::Calc::add_two_u8 --args 15u8 27u8


//# run 0xCAFE::Calc::apply_lambda --args 11u8


//# run 0xCAFE::Caller::call_add


//# run 0xCAFE::Caller::call_lambda


//# run 0xCAFE::Caller::call_inline_double --args 21u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
