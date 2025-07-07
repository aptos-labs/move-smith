
//# publish
module 0xCAFE::AddModule {
    public fun add_and_adjust(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 100) {
            100
        } else {
            sum + 1
        };
        result
    }

    public fun lambda_example(x: u8): u8 {
        let add_two: |u8| u8 has copy+drop = |v: u8| { v + 2 };
        let mul_three: |u8| u8 has copy+drop = |v: u8| { v * 3 };
        let intermediate = add_two(x);
        mul_three(intermediate)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun caller_function(a: u8, b: u8): u8 {
        let added = AddModule::add_and_adjust(a, b);
        // Call inline function from AddModule
        let incremented = AddModule::inline_increment(added);
        incremented
    }
}


//# run 0xCAFE::AddModule::add_and_adjust --args 40u8 50u8


//# run 0xCAFE::AddModule::lambda_example --args 5u8


//# run 0xCAFE::CallerModule::caller_function --args 40u8 50u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
