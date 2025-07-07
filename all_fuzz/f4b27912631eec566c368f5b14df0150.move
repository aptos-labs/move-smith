
//# publish
module 0xCAFE::CalcModule {
    // A module to test addition of two u8 values and return a specific value
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 as a specific result to distinguish
        sum + 1
    }

    // Function that contains a lambda expression doubling a u8 number
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        doubler(x)
    }
}


//# run 0xCAFE::CalcModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::CalcModule::double_with_lambda --args 15u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    // Calls CalcModule's inline call through nested calls
    public inline fun inner_call(x: u8, y: u8): u8 {
        CalcModule::add_and_return_sum(x, y)
    }

    // Calls inline function through a wrapper function to test nested calls and inline expansion
    public fun outer_call(x: u8, y: u8): u8 {
        inner_call(x, y)
    }
}


//# run 0xCAFE::CallerModule::outer_call --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
