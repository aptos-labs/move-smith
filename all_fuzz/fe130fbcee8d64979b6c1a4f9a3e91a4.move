
//# publish
module 0xCAFE::AddModule {
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum offset by 10
        sum + 10
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun use_add_and_offset(a: u8, b: u8): u8 {
        AddModule::add_and_offset(a, b)
    }

    public fun lambda_through_call(x: u8, y: u8): u8 {
        AddModule::with_lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 3u8 4u8


//# run 0xCAFE::AddModule::with_lambda --args 5u8 7u8


//# run 0xCAFE::NestedCallModule::call_inline_add --args 6u8 7u8


//# run 0xCAFE::NestedCallModule::use_add_and_offset --args 1u8 2u8


//# run 0xCAFE::NestedCallModule::lambda_through_call --args 8u8 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
