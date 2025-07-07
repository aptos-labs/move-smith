
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to differentiate from just the sum
        sum + 1
    }
    
    public fun run_lambda_example(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(10u8, 15u8)
    }
    
    // This inline function adds 100 to its argument
    public inline fun inline_add_100(a: u8): u8 {
        a + 100
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::AdditionModule::run_lambda_example


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let sum = a + b;
        let result_inline = AdditionModule::inline_add_100(sum);
        result_inline
    }

    public fun nested_calls(): u8 {
        let val1 = AdditionModule::add_and_return_sum(5u8, 5u8);
        let val2 = call_inline_and_add(10u8, 20u8);
        val1 + val2
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_add --args 30u8 20u8


//# run 0xCAFE::NestedCallModule::nested_calls


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
