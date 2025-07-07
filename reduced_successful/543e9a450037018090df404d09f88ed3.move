
//# publish
module 0xCAFE::AddModule {
    // Module for testing addition function on u8 values

    public fun add_two_numbers(a: u8, b: u8): u8 {
        let c = a + b;
        // Return c + 5 to check the final value is correct
        c + 5
    }

    public fun lambda_add() {
        let add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let _result = add(7u8, 8u8);
    }

    public fun lambda_use_in_loop() {
        let add_one: |u8|u8 has copy+drop = |x: u8| { x + 1u8 };
        let x = 0u8;
        while (x < 3u8) {
            x = add_one(x);
        };
    }
}


//# run 0xCAFE::AddModule::add_two_numbers --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_add


//# run 0xCAFE::AddModule::lambda_use_in_loop


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Call the add_two_numbers function from AddModule and add 10 to the result
    public fun call_add_and_add_more(a: u8, b: u8): u8 {
        let result = AddModule::add_two_numbers(a, b);
        result + 10u8
    }

    // Call AddModule's lambda_add and lambda_use_in_loop to test nested calls
    public fun call_lambdas() {
        AddModule::lambda_add();
        AddModule::lambda_use_in_loop();
    }
}


//# run 0xCAFE::CallerModule::call_add_and_add_more --args 5u8 15u8


//# run 0xCAFE::CallerModule::call_lambdas


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
