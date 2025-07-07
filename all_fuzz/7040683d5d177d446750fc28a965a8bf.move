
//# publish
module 0xCAFE::MathModule {
    // Module to test addition and inline functions with tuple returns

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun call_inline_and_add(a: u16, b: u16): u16 {
        let (x, y) = Self::inline_add_and_double(a);
        x + y + b
    }

    public inline fun inline_add_and_double(x: u16): (u16, u16) {
        (x, x * 2)
    }

    public fun tuple_example(): (u8, u16, bool) {
        (42u8, 999u16, true)
    }
}


//# run 0xCAFE::MathModule::add_two_values --args 10u8 20u8


//# run 0xCAFE::MathModule::call_inline_and_add --args 5u16 3u16


//# run 0xCAFE::MathModule::tuple_example



//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambda (anonymous function) expressions

    public fun use_lambda_simple(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        lambda(a, b)
    }

    public fun use_lambda_complex(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }

    public fun nested_lambda(x: u8): u8 {
        let add_one: |u8| u8 has copy+drop = |v: u8| { v + 1 };
        let double: |u8| u8 has copy+drop = |v: u8| { v * 2 };
        let composed: |u8| u8 has copy+drop = |v: u8| { double(add_one(v)) };
        composed(x)
    }
}


//# run 0xCAFE::LambdaModule::use_lambda_simple --args 7u8 8u8


//# run 0xCAFE::LambdaModule::use_lambda_complex --args 4u8 5u8


//# run 0xCAFE::LambdaModule::nested_lambda --args 3u8



//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::MathModule;

    public fun test_nested_call(val1: u16, val2: u16): u16 {
        MathModule::call_inline_and_add(val1, val2)
    }

    public fun call_and_unpack_tuple(): u8 {
        let (a, _b, c) = MathModule::tuple_example();
        if (c) { a } else { 0u8 }
    }
}


//# run 0xCAFE::CrossModuleCall::test_nested_call --args 10u16 20u16


//# run 0xCAFE::CrossModuleCall::call_and_unpack_tuple


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 25c15f69e7c925a2f6451b6abc0f3011: Create multi-value expression lists (tuples or similar).
