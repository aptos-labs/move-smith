
//# publish
module 0xCAFE::AddModuleV2 {
    // Test 1: Function that adds two u8 values and returns a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    // Test 2: Function containing lambda expressions to add and multiply
    public fun lambda_operations(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        (add_lambda(a, b), mul_lambda(a, b))
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModuleV2;

    // Test 3: Call add_and_return from AddModuleV2 inline to produce nested calls result
    public fun nested_calls(a: u8, b: u8): u8 {
        let intermediate = AddModuleV2::add_and_return(a, b);
        let final_value = intermediate + 5u8;
        final_value
    }
}


//# publish
module 0xCAFE::VariableUpdate {
    // Test 5: Multiple sequential updates to local variable are correctly accumulated
    public fun accumulate_updates(initial: u8): u8 {
        let temp = initial + 3u8;
        let temp = temp + 4u8;
        let temp = temp + 5u8;
        temp
    }
}


//# run 0xCAFE::AddModuleV2::add_and_return --args 12u8 23u8


//# run 0xCAFE::AddModuleV2::lambda_operations --args 3u8 5u8


//# run 0xCAFE::InlineCaller::nested_calls --args 4u8 6u8


//# run 0xCAFE::VariableUpdate::accumulate_updates --args 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 26d44b341b304f9a1deb408a6a646899: Use Move language version 2.0 or higher for specific language constructs.
// 2baf1ad04dd93499c7dba7597bb32763: Test that multiple sequential updates to a local variable are correctly accumulated and summed across multiple expressions.
