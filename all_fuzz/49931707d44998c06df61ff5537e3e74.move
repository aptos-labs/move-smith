
//# publish
module 0xCAFE::TestFuncs {
    // Simple add function returning sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function defining a lambda that multiplies input by 2
    public fun lambda_double(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        doubler(x)
    }

    // Inline function returning triple of input
    public inline fun triple(x: u8): u8 {
        x * 3
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::TestFuncs;

    // Call add_and_offset from TestFuncs and add 5 to result
    public fun call_add_and_offset(a: u8, b: u8): u8 {
        let res = TestFuncs::add_and_offset(a, b);
        res + 5
    }

    // Call inline triple function from TestFuncs
    public fun use_inline_triple(x: u8): u8 {
        TestFuncs::triple(x)
    }

    // Call lambda function in TestFuncs by indirectly calling lambda_double
    public fun call_lambda_double(x: u8): u8 {
        TestFuncs::lambda_double(x)
    }
}


//# run 0xCAFE::TestFuncs::add_and_offset --args 10u8 20u8


//# run 0xCAFE::TestFuncs::lambda_double --args 7u8


//# run 0xCAFE::CallerModule::call_add_and_offset --args 10u8 20u8


//# run 0xCAFE::CallerModule::use_inline_triple --args 4u8


//# run 0xCAFE::CallerModule::call_lambda_double --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
