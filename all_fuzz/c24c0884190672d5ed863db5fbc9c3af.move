
//# publish
module 0xCAFE::AddModule {
    // A simple module to test addition of two u8 values and return a result

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to differentiate the return value
        sum + 10
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 5u8 6u8


//# run 0xCAFE::AddModule::use_lambda --args 12u8 8u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    // Function to call AddModule::add_and_return and AddModule::use_lambda inline
    public fun call_add_and_lambda(x: u8, y: u8): (u8, u8) {
        let res1 = AddModule::add_and_return(x, y);
        let res2 = AddModule::use_lambda(x, y);

        (res1, res2)
    }
}


//# run 0xCAFE::NestedCallModule::call_add_and_lambda --args 7u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
