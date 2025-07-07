
//# publish
module 0xCAFE::MathModule {
    // Simple function adding two u8 and returning u8
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to ensure a specific offset
        sum + 10
    }

    // Function containing and using a lambda (anonymous function)
    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * 2 + y * 3
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::MathModule::add_two_numbers --args 5u8 7u8



//# run 0xCAFE::MathModule::use_lambda --args 2u8 3u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    // Inline function calling MathModule::add_two_numbers twice with different values,
    // adding the results and returning it.
    public fun inline_caller(a: u8, b: u8): u8 {
        let first = MathModule::add_two_numbers(a, b);
        let second = MathModule::add_two_numbers(b, a);
        first + second
    }

    // Runner function to exercise nested call of inline function with lambdas
    public fun runner(): u8 {
        let val1 = inline_caller(1u8, 2u8);
        let val2 = MathModule::use_lambda(3u8, 4u8);
        val1 + val2
    }
}



//# run 0xCAFE::CallerModule::inline_caller --args 10u8 20u8



//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
