
//# publish
module 0xCAFE::MathUtils {
    public inline fun add_two_u8(x: u8, y: u8): u8 {
        x + y
    }

    public fun add_and_return_constant(x: u8, y: u8): u8 {
        let sum = add_two_u8(x, y);
        // Return constant 42, after computing sum (unused)
        42u8
    }

    public fun lambda_adder() {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = add_lambda(10u8, 32u8);

        // Copy lambda and call again
        let copy_lambda = copy add_lambda;
        let _ = copy_lambda(5u8, 6u8);
    }

    public inline fun inline_add_two_u16(x: u16, y: u16): u16 {
        x + y
    }
}


//# run 0xCAFE::MathUtils::add_and_return_constant --args 12u8 30u8


//# run 0xCAFE::MathUtils::lambda_adder


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::MathUtils;

    public fun call_inline_and_add(x: u16, y: u16): u16 {
        let sum = MathUtils::inline_add_two_u16(x, y);
        sum + 1u16
    }
}


//# run 0xCAFE::Caller::call_inline_and_add --args 100u16 22u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
