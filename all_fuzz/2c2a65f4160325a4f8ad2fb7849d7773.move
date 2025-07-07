
//# publish
module 0xCAFE::AddModule {
    /// Adds two u8 numbers and returns their sum plus a constant offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let offset = 10u8;
        sum + offset
    }

    /// Function that returns a lambda (anonymous function) for multiplying two u8 numbers
    public fun make_multiplier(): |u8, u8|u8 {
        |x: u8, y: u8| {
            x * y
        }
    }

    /// Calls the multiplier lambda returned from make_multiplier with given arguments
    public fun call_multiplier(a: u8, b: u8): u8 {
        let mul = make_multiplier();
        mul(a, b)
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 5u8 7u8


//# run 0xCAFE::AddModule::call_multiplier --args 3u8 4u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    /// Calls the AddModule::add_and_offset inline function with transformed arguments
    public fun call_add_with_transformation(x: u8, y: u8): u8 {
        // Call AddModule::add_and_offset with (x + 1) and (y + 1)
        let (a, b) = (x + 1, y + 1);
        AddModule::add_and_offset(a, b)
    }

    /// Function that uses a lambda to add two numbers and then calls AddModule's multiplier lambda for the result and a factor
    public fun combined_lambda_operations(x: u8, y: u8, factor: u8): u8 {
        let add_lambda: |u8, u8|u8 = |a: u8, b: u8| {
            a + b
        };
        let sum = add_lambda(x, y);
        let mul_lambda = AddModule::make_multiplier();
        mul_lambda(sum, factor)
    }
}


//# run 0xCAFE::CallerModule::call_add_with_transformation --args 4u8 5u8


//# run 0xCAFE::CallerModule::combined_lambda_operations --args 2u8 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
