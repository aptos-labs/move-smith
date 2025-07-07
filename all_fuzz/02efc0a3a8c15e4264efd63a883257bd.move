
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return the sum plus 5 for testing a specific return value
        sum + 5
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = adder(a, b);
        // Return result plus 10 as a special indicator
        result + 10
    }
}


//# run 0xCAFE::AdditionModule::add_two_values --args 10u8 20u8


//# run 0xCAFE::AdditionModule::add_with_lambda --args 15u8 25u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun compute_and_increment(x: u8, y: u8): u8 {
        let base_sum = AdditionModule::add_two_values(x, y); // calls add_two_values which returns sum+5
        base_sum + 1u8
    }

    public fun runner() {
        let _result = compute_and_increment(3u8, 4u8);
    }
}


//# run 0xCAFE::NestedCallModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
