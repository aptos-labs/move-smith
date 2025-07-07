
//# publish
module 0xCAFE::LambdaTests {
    use std::vector;

    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 5 as a fixed offset to test addition correctness
        sum + 5
    }

    public fun lambda_example(x: u8): u8 {
        let anon_func: |u8| u8 has copy + drop = |n: u8| {
            n * 2
        };
        let doubled = anon_func(x);
        doubled + 1
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun caller_of_inline(a: u8, b: u8): u8 {
        let result = inline_adder(a, b);
        result + 10
    }
}


//# run 0xCAFE::LambdaTests::add_two_u8_values --args 3u8 4u8


//# run 0xCAFE::LambdaTests::lambda_example --args 7u8


//# run 0xCAFE::LambdaTests::caller_of_inline --args 2u8 3u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTests;

    public fun call_lambda_tests_addition(): u8 {
        LambdaTests::add_two_u8_values(6, 7)
    }

    public fun call_lambda_tests_lambda(): u8 {
        LambdaTests::lambda_example(8)
    }

    public fun call_lambda_tests_inline(a: u8, b: u8): u8 {
        LambdaTests::caller_of_inline(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_lambda_tests_addition


//# run 0xCAFE::CallerModule::call_lambda_tests_lambda


//# run 0xCAFE::CallerModule::call_lambda_tests_inline --args 5u8 6u8


//# publish
module 0xCAFE::SpecBlockTest {
    spec module {
        use 0xCAFE::LambdaTests;
        use 0xCAFE::CallerModule;

        // Spec block with some dummy ensures for compilation exercise purposes
        // No real execution impact, but 'use' is tested here
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d7586a9eca0243621ef9fbddf6282992: Include 'use' declarations inside spec blocks to import modules or components.
