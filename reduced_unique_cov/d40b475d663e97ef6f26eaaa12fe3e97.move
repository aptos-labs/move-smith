
//# publish
module 0xCAFE::CallerModule {
    // CallerModule should be published first because CalcModule declares it as friend

    // No additional code needed here; placeholder to allow friend declarations
}



//# publish
module 0xCAFE::CalcModule {
    // Module to test addition and inline function calls

    friend 0xCAFE::CallerModule; // friend declaration ends with semicolon

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 to distinguish result
        sum + 10
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambdas and function parameters

    public fun apply_lambda_to_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun accept_function_and_apply(f: |u8, u8|u8, a: u8, b: u8): u8 {
        f(a, b)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;
    use 0xCAFE::LambdaModule;

    friend 0xCAFE::CalcModule;

    // This function tests nested calls and friend declarations
    public fun nested_call_and_add(a: u8, b: u8): u8 {
        let temp = CalcModule::inline_add(a, b);
        CalcModule::add_two_values(temp, 5)
    }

    public fun lambda_with_inline_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            CalcModule::inline_add(x, y)
        };
        LambdaModule::accept_function_and_apply(lambda, a, b)
    }

    public fun choose_example(): u8 {
        let chosen = choose x: u8 in {
            x > 10
        };
        chosen
    }
}



//# run 0xCAFE::CalcModule::add_two_values --args 3u8 4u8



//# run 0xCAFE::LambdaModule::apply_lambda_to_sum --args 5u8 6u8



//# run 0xCAFE::CallerModule::nested_call_and_add --args 3u8 4u8



//# run 0xCAFE::CallerModule::lambda_with_inline_lambda --args 7u8 8u8



//# run 0xCAFE::CallerModule::choose_example


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// fe6a973bbced6f5a4f50cbd27a92afd4: Terminate friend declarations with a semicolon.
// 963ab02ce5f0914f7386f6d2ef6ed632: Test that functions accepting function parameters (like closures/lambdas) work correctly when passed inline anonymous functions.
// 5edb1d8435eca69454744134ffaee6e9: Use 'choose' quantifiers to select a value satisfying a given condition.
