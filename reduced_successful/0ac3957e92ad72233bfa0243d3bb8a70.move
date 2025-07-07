
//# publish
module 0xCAFE::AddModule {
    // Simple function that adds two u8 values and returns a constant afterward.
    public fun add_and_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum;
        42u8
    }

    // A function that contains a lambda to add two numbers and then calls it.
    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| x + y;
        add_lambda(a, b)
    }

    // A runner function without arguments to call lambda internally.
    public fun runner_lambda() {
        let _res = lambda_add(10u8, 20u8);
    }
}


//# run 0xCAFE::AddModule::add_and_return_const --args 5u8 7u8


//# run 0xCAFE::AddModule::lambda_add --args 1u8 2u8


//# run 0xCAFE::AddModule::runner_lambda



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    // Calls the inline inline_function_two to get tuple and add with input plus other manipulations.
    public inline fun inline_function_two(x: u16): (u16, u16) {
        (x + 10, x + 20)
    }

    // Calls inline inline_function_two to get tuple, adds up and calls AddModule::lambda_add.
    public fun nested_calls(a: u8, b: u8, c: u16): u8 {
        let (v1, v2) = inline_function_two(c);
        let sum_u16 = v1 + v2; // u16 sum
        let sum_u8 = (sum_u16 % 256) as u8;
        AddModule::lambda_add(a, b) + sum_u8
    }

    public fun test_call_nested() {
        let _res = nested_calls(2u8, 3u8, 5u16);
    }
}


//# run 0xCAFE::NestedCallModule::nested_calls --args 1u8 2u8 3u16


//# run 0xCAFE::NestedCallModule::test_call_nested


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
