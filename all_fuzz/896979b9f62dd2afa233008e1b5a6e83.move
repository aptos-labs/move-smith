
//# publish
module 0xCAFE::MathUtilities {
    //// Simple math utility module

    public fun add_and_return_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 for some offset
        sum + 10
    }

    public fun lambda_double(x: u8): u8 {
        let double_it: |u8|u8 has copy+drop = |y: u8| {
            y * 2
        };
        double_it(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::MathUtilities::add_and_return_value --args 5u8 7u8


//# run 0xCAFE::MathUtilities::lambda_double --args 6u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathUtilities;

    // Call inline function from MathUtilities and do further calculation
    public fun nested_calls(x: u8, y: u8): u8 {
        let added = MathUtilities::inline_add(x, y);
        // Return added * 3 as test
        added * 3
    }

    public fun runner() {
        let _ = nested_calls(4u8, 5u8);
        let _ = MathUtilities::add_and_return_value(1u8, 1u8);
        let _ = MathUtilities::lambda_double(10u8);
    }
}


//# run 0xCAFE::CallerModule::runner


//# run 0xCAFE::CallerModule::nested_calls --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
