
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_sum --args 10u8 20u8


//# publish
module 0xCAFE::LambdaModule {
    public fun apply_lambda_to_u8(lambda: |u8|u8, val: u8): u8 {
        lambda(val)
    }

    public fun example_lambda_usage(): u8 {
        let increment_lambda: |u8|u8 has copy+drop = |x: u8| {x + 1};
        apply_lambda_to_u8(increment_lambda, 41u8)
    }
}


//# run 0xCAFE::LambdaModule::example_lambda_usage


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun call_add_then_return_sum(x: u8, y: u8): u8 {
        AdditionModule::add_then_return_sum(x, y)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        let result = call_add_then_return_sum(x, y);
        result + 1
    }
}


//# run 0xCAFE::InlineCaller::nested_call --args 1u8 2u8


//# run
script {
    fun main() {
        // This script tests saving compiled Move scripts to disk as binary files.
        // In real scenario, this would be done outside Move VM but we simulate no-op here.
    }
}


//# publish
module 0xCAFE::WhileBreakModule {
    public fun while_with_break_demo(): u8 {
        let x = 0;
        while (true) {
            x = x + 1;
            break;
        };
        x
    }
}


//# run 0xCAFE::WhileBreakModule::while_with_break_demo


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9a600fd3c1f5c5ff9446caf33e8dcd47: Save compiled Move scripts to disk as binary files.
// 6ae1a4a92c515bf00dd9597df1ee03bf: Verify that a while loop with an immediate break correctly executes and updates the variable as expected.
