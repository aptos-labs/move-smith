
//# publish
module 0xCAFE::AdditionModule {
    // A simple function to add two u8 values and then add 10 before returning
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function with lambdas: returns results of different lambda calls
    public fun lambda_tests(): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x * y };

        let add_result = add_lambda(3, 4);
        let mul_result = mul_lambda(5, 6);

        (add_result, mul_result)
    }
}


//# run 0xCAFE::AdditionModule::add_and_offset --args 5u8 10u8


//# run 0xCAFE::AdditionModule::lambda_tests


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Calls the inline function f2 from AdditionModule indirectly by defining it here first
    // Actually, AdditionModule has no f2, so let's define an inline function here and call it.

    // Inline function that returns a tuple (sum and difference)
    public inline fun inline_add_sub(a: u8, b: u8): (u8, u8) {
        (a + b, b - a)
    }

    // Function calling inline_add_sub; then calls AdditionModule::add_and_offset with sum from inline_add_sub
    public fun call_nested_functions(x: u8, y: u8): u8 {
        let (sum, _diff) = inline_add_sub(x, y);
        // call AdditionModule::add_and_offset with sum and y
        AdditionModule::add_and_offset(sum, y)
    }
}


//# run 0xCAFE::CallerModule::call_nested_functions --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
