
//# publish
module 0xCAFE::MathOps {
    // Test addition and returning a constant value.

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return_const(x: u8, y: u8): u8 {
        let sum = add_u8(x, y);
        let _lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 1
        };
        let incremented = _lambda(sum);
        // Return a fixed u8 value to test return of constants.
        42u8
    }

    // A function containing lambda expressions invoking each other.
    public fun nested_lambda_ops(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };

        let double_lambda: |u8| u8 has copy+drop = |a: u8| {
            let result = add_lambda(a, a);
            result
        };

        double_lambda(y) + add_lambda(x, y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathOps;

    /// Inline function calling an inline function from another module.
    public inline fun nested_call(a: u8, b: u8): u8 {
        let sum = MathOps::add_u8(a, b);
        sum + 10u8
    }

    /// Runner function that calls nested_call then returns the result.
    public fun runner(): u8 {
        nested_call(7u8, 8u8)
    }
}


//# run 0xCAFE::MathOps::compute_and_return_const --args 12u8 30u8


//# run 0xCAFE::MathOps::nested_lambda_ops --args 4u8 5u8


//# run 0xCAFE::CallerModule::runner


// The following pragma instructs the bytecode verifier to ignore maximum function size warnings for this module
pragma verify(user);

// The following pragma will conditionally generate no native functions for this module (doesn't affect runtime in this test)
pragma code_gen(none);


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f94576fe76fd284416a605c3e0607384: Add pragmas to guide verification or compilation.
