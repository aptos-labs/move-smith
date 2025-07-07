
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_const(x: u8, y: u8): u8 {
        let sum = x + y;
        // The constant to return regardless of sum
        42u8
    }

    public fun with_lambda_calls(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = add_lambda(x, y);
        result
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_const --args 10u8 20u8


//# run 0xCAFE::AdditionModule::with_lambda_calls --args 7u8 8u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_increment(x: u8): u8 {
        AdditionModule::inline_increment(x)
    }

    public fun nested_calls_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let nested_result = AdditionModule::inline_increment(a);
            nested_result + b
        };
        lambda(x, y)
    }

    public fun labeled_loops_counter(): u8 {
        let counter = 0u8;

        'outer: while (counter < 3) {
            let inner_counter = 0u8;

            'inner: loop {
                if (inner_counter == 2) {
                    break 'outer;
                };
                counter = counter + 1;
                inner_counter = inner_counter + 1;
            };
        };
        counter
    }
}


//# run 0xCAFE::CallerModule::call_inline_increment --args 41u8


//# run 0xCAFE::CallerModule::nested_calls_with_lambda --args 10u8 5u8


//# run 0xCAFE::CallerModule::labeled_loops_counter


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a791c4dede4e869e176f5f9a9ac8d6f6: Write labeled loops such as 'label: while' or 'label: loop'.
