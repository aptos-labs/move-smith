
//# publish
module 0xCAFE::TestAdd {
    // A simple function to add two u8 values and then add 10 to the result, returning the final u8.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }
}


//# publish
module 0xCAFE::LambdaTest {
    // Function defining and using a lambda that multiplies an input by 2.
    public fun double_with_lambda(x: u8): u8 {
        let double: |u8|u8 has copy+drop = |v: u8| {
            v * 2u8
        };
        double(x)
    }

    // Function using a lambda that captures a variable and adds it to its argument.
    public fun add_captured_value(x: u8): u8 {
        let captured = 5u8;
        let add_lambda: |u8|u8 has copy+drop = |v: u8| {
            v + captured
        };
        add_lambda(x)
    }

    // Runner function calling above lambdas for coverage
    public fun run() {
        let _ = Self::double_with_lambda(7u8);
        let _ = Self::add_captured_value(3u8);
    }
}


//# publish
module 0xCAFE::CrossModuleInlineCall {
    use 0xCAFE::TestAdd;

    // Calls the inline function in TestAdd and then adds 20 to result
    public inline fun call_add_and_offset(a: u8, b: u8): u8 {
        let base_result = TestAdd::add_and_offset(a, b);
        base_result + 20u8
    }

    // Runner function to call call_add_and_offset with preset values
    public fun run() {
        let _ = Self::call_add_and_offset(1u8, 2u8);
    }
}


//# run 0xCAFE::TestAdd::add_and_offset --args 10u8 20u8


//# run 0xCAFE::LambdaTest::run


//# run 0xCAFE::CrossModuleInlineCall::run


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
