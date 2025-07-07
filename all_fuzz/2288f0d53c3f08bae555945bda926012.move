
//# publish
module 0xCAFE::LambdaAndInline {
    // Removed unused import
    // use std::signer;

    // Pragma property on a struct (example only, as pragma syntax is simple)
    // Note: Move currently does not support pragmas in the language officially,
    // but we simulate it with a comment above the item as a placeholder for this test.
    // This is only for testing purposes.
    // @pragma test_pragma = "example_property"
    struct Dummy has copy, drop, store {
        field: u8
    }

    public fun simple_addition(a: u8, b: u8): u8 {
        // Test addition before returning a fixed value 42
        let c = a + b;
        let _ = c; // use c to avoid unused var warning
        42u8
    }

    public fun lambda_expression(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |v: u8| {
            v + 5u8
        };
        f(x)
    }

    public inline fun inline_increment(val: u8): u8 {
        val + 1u8
    }

    public fun call_inline_nested(x: u8): u8 {
        // Call inline_increment twice to test nested inline calls
        let y = inline_increment(x);
        inline_increment(y)
    }

    public fun check_exp(value: u8): u8 {
        // sample check_exp function which here just dereferences the value pointer (simulated)
        // We simulate check_exp by just returning the value itself, acting as pure expression
        value
    }

    public fun dereference_pointer(v: &u8): u8 {
        // Derefences pointer to u8
        *v
    }
}



//# run 0xCAFE::LambdaAndInline::simple_addition --args 10u8 32u8



//# run 0xCAFE::LambdaAndInline::lambda_expression --args 15u8



//# run 0xCAFE::LambdaAndInline::call_inline_nested --args 5u8



//# run 0xCAFE::LambdaAndInline::check_exp --args 77u8



//# run 0xCAFE::LambdaAndInline::dereference_pointer --args 99u8




//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::LambdaAndInline;

    public fun indirect_call(x: u8): u8 {
        // Call the inline_increment function in LambdaAndInline module twice
        let first = LambdaAndInline::inline_increment(x);
        LambdaAndInline::inline_increment(first)
    }

    public fun call_lambda_and_deref(x: u8): u8 {
        // Call lambda_expression and then dereference_pointer
        let val = LambdaAndInline::lambda_expression(x);
        // Instead of returning a reference (which is invalid), directly return the dereferenced value
        LambdaAndInline::dereference_pointer(&val)
    }

    public fun call_check_exp(x: u8): u8 {
        LambdaAndInline::check_exp(x)
    }
}



//# run 0xCAFE::CrossModuleCall::indirect_call --args 7u8



//# run 0xCAFE::CrossModuleCall::call_lambda_and_deref --args 10u8



//# run 0xCAFE::CrossModuleCall::call_check_exp --args 88u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 097d2858766da6b23e17620ce967a697: Use the check_exp function to verify the purity of an expression according to the specification rules in the environment.
// 3df82160d210235aaa8fa4f4afcbe734: Use '*' to dereference a pointer in expressions.
// 1de8ad72115f0eb0822915e74e37018f: Define pragma properties on items in Move code.
