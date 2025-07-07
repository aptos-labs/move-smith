
//# publish
module 0xCAFE::Arithmetic {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 regardless of sum
        42
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Arithmetic::add_then_return_fixed --args 10u8 20u8


//# run 0xCAFE::Arithmetic::add_with_lambda --args 15u8 25u8


//# publish
module 0xCAFE::OuterModule {
    use 0xCAFE::Arithmetic;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Arithmetic::inline_add(a, b)
    }

    public fun nested_calls_trigger(): u8 {
        // Call add_then_return_fixed which returns 42
        let fixed = Arithmetic::add_then_return_fixed(3, 4);
        // Call add_with_lambda which does addition
        let lambda_sum = Arithmetic::add_with_lambda(5, 6);
        // Call inline_add through this module
        let inline_sum = call_inline_add(7, 8);
        fixed + lambda_sum + inline_sum
    }
}


//# run 0xCAFE::OuterModule::call_inline_add --args 100u8 44u8


//# run 0xCAFE::OuterModule::nested_calls_trigger


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
