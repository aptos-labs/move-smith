
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // Use sum to practice a value; returned fixed 42u8
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddModule;

    public fun call_inline_then_add(x: u8, y: u8): u8 {
        let inner_sum = AddModule::inline_add(x, y);
        AddModule::add_then_return_fixed(inner_sum, 1u8)
    }
}


//# run 0xCAFE::AddModule::add_then_return_fixed --args 5u8 6u8


//# run 0xCAFE::AddModule::use_lambda --args 10u8 15u8


//# run 0xCAFE::NestedCalls::call_inline_then_add --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
