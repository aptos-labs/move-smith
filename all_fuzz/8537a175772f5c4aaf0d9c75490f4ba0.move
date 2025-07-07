
//# publish
module 0xCAFE::NestedCallModule {
    public inline fun inline_add(a: u8, b: u8): (u8, u8) {
        (a + b, b)
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        let (sum, _) = inline_add(a, b);
        sum
    }
}


//# publish
module 0xCAFE::LambdaTestModule {
    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 1
        };
        lambda(x)
    }

    public fun apply_lambda_twice(x: u8): u8 {
        let add_one: |u8| u8 has copy+drop = |a: u8| { a + 1 };
        let add_two: |u8| u8 has copy+drop = |a: u8| { add_one(add_one(a)) };
        add_two(x)
    }
}


//# publish
module 0xCAFE::ComputationModule {
    use 0xCAFE::NestedCallModule;
    use 0xCAFE::LambdaTestModule;

    // Function that computes addition of two u8 values and returns a fixed u8 value after summation
    public fun compute_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // After summation return a fixed value, say 42u8
        42u8
    }

    // Function that uses a lambda expression to add 10 to input
    public fun lambda_add_ten(x: u8): u8 {
        let add_ten: |u8| u8 has copy+drop = |a: u8| { a + 10 };
        add_ten(x)
    }

    // Function that calls inline function from NestedCallModule and then applies lambda from LambdaTestModule
    public fun nested_calls(a: u8, b: u8): u8 {
        let sum = NestedCallModule::call_inline_add(a, b);
        let incremented = LambdaTestModule::apply_lambda(sum);
        incremented
    }
}


//# run 0xCAFE::ComputationModule::compute_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::ComputationModule::lambda_add_ten --args 5u8


//# run 0xCAFE::ComputationModule::nested_calls --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
