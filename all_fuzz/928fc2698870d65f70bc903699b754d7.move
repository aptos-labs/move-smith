
//# publish
module 0xCAFE::AddModule {
    // This module tests addition of two u8 values and returns a fixed u8 value

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum: u8 = a + b;
        42u8
    }

    public fun call_lambda_with_args(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::AddModule::call_lambda_with_args --args 7u8 8u8



//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::AddModule;

    // Calls inline function from AddModule and adds extra logic

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let sum = AddModule::inline_adder(x, y);
        sum + 1u8
    }

    public fun test_nested_calls(): u8 {
        let a = 5u8;
        let b = 6u8;
        call_inline_and_add(a, b)
    }
}


//# run 0xCAFE::CallInlineModule::call_inline_and_add --args 10u8 20u8


//# run 0xCAFE::CallInlineModule::test_nested_calls



//# publish
module 0xCAFE::LintTestModule {
    // This module is for testing Move linter checks with non-native functions

    // Function with many local variables and inline conditions
    public fun complicated_logic(a: u8, b: u8): u8 {
        let mut_a = a;
        let mut_b = b;
        if (mut_a > mut_b) {
            mut_a
        } else {
            mut_b
        };
        let result = if (a == b) { 0u8 } else { 1u8 };
        result
    }

    // Function with arithmetic operations and no return statement (returns unit)
    public fun void_func(x: u8) {
        let _y = x + 1;
        let _z = x * 2;
    }
}


//# run 0xCAFE::LintTestModule::complicated_logic --args 3u8 5u8


//# run 0xCAFE::LintTestModule::void_func --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2bb8788985e13a0a6c230da263b8553b: Write non-native functions in modules to be subject to external Move lint checking according to the configured checkers.
