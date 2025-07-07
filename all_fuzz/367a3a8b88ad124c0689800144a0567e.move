
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_check(a: u8, b: u8): u8 {
        let result = a + b;
        if (result > 100) {
            100
        } else {
            result
        }
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(6u8, 7u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    public inline fun inline_double(a: u8): u8 {
        a * 2
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let added = LambdaTest::add_and_check(x, y);
        let doubled = inline_double(added);
        doubled
    }
}


//# run 0xCAFE::LambdaTest::add_and_check --args 50u8 51u8


//# run 0xCAFE::LambdaTest::add_and_check --args 30u8 40u8


//# run 0xCAFE::LambdaTest::run_lambda_example


//# run 0xCAFE::CallerModule::call_nested_functions --args 30u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
