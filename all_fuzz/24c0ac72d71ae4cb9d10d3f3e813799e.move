
//# publish
module 0xCAFE::MathModule {
    // Test addition of two u8 values and then return a fixed u8 result (42)
    public fun add_then_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // Just to demonstrate sum is used
        42u8
    }

    // Function with a lambda expression that multiplies two u8 values
    public fun lambda_multiply(x: u8, y: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        multiply(x, y)
    }

    // An inline function to add three u8 values
    public inline fun add_three(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }
}


//# run 0xCAFE::MathModule::add_then_fixed_value --args 10u8 20u8


//# run 0xCAFE::MathModule::lambda_multiply --args 6u8 7u8


//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::MathModule;

    // Calls the inline add_three function from MathModule with given args and adds 1 more
    public fun call_mathmodule_add_three() : u8 {
        // calls add_three in MathModule with 1, 2, 3 then adds 1 to result
        let result = MathModule::add_three(1u8, 2u8, 3u8);
        let final_result = result + 1u8;
        final_result
    }
}


//# run 0xCAFE::CallInlineModule::call_mathmodule_add_three


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
