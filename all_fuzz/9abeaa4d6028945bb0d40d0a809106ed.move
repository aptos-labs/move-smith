
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum incremented by 10
        sum + 10
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(a, b);
        // Return result plus a fixed offset 5
        result + 5
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Call AddModule::add_two_values and AddModule::use_lambda and combine results
    public fun nested_calls(x: u8, y: u8): u8 {
        let res1 = AddModule::add_two_values(x, y);
        let res2 = AddModule::use_lambda(x, y);
        res1 + res2
    }

    // Runner without arguments to test nested_calls with some fixed values
    public fun runner(): u8 {
        nested_calls(7, 8)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 3u8 4u8


//# run 0xCAFE::AddModule::use_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::nested_calls --args 3u8 4u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
