
//# publish
module 0xCAFE::AdditionModule {
    /// Adds two u8 values and returns the sum plus a fixed constant 10u8.
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    /// Uses a lambda to add two u8 values and returns the result multiplied by 2.
    public fun lambda_double_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result * 2u8
    }
    
    /// Inline function that returns sum of three u8 values.
    public inline fun inline_sum_3(x: u8, y: u8, z: u8): u8 {
        x + y + z
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    /// Calls AdditionModule::inline_sum_3 twice and returns total.
    public fun nested_sum(x: u8, y: u8, z: u8): u8 {
        let first_call = AdditionModule::inline_sum_3(x, y, z);
        let second_call = AdditionModule::inline_sum_3(z, y, x);
        first_call + second_call
    }
}


//# run 0xCAFE::AdditionModule::add_and_return --args 12u8 8u8


//# run 0xCAFE::AdditionModule::lambda_double_add --args 5u8 7u8


//# run 0xCAFE::NestedCallModule::nested_sum --args 1u8 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
