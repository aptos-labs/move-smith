
//# publish
module 0xCAFE::MathModule {
    // Module to test simple addition u8 and return a specific u8 value

    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // return fixed 42 after computing sum, to check correct addition logic
        42
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        // Lambda to multiply two u8s and add 1
        let my_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y + 1
        };
        my_lambda(a, b)
    }
}


//# run 0xCAFE::MathModule::add_and_return_specific --args 20u8 22u8


//# run 0xCAFE::MathModule::use_lambda --args 5u8 7u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        // Call inline fun from this module first
        let inc = inline_increment(a);
        // Call lambda inside MathModule
        let lambda_result = MathModule::use_lambda(inc, b);
        lambda_result
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_lambda --args 1u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
