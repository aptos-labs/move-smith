
//# publish
module 0xCAFE::AdditionModule {
    // Test that the Move function correctly computes the addition of two u8 values
    // before returning a specific value.

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    // Changed visibility from `fun` (private) to `public` 
    public inline fun inline_addition(x: u8, y: u8): u8 {
        add(x, y)
    }

    public inline fun add(x: u8, y: u8): u8 {
        x + y
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_sum --args 7u8 8u8



//# run 0xCAFE::AdditionModule::with_lambda --args 9u8 10u8




//# publish
module 0xCAFE::NestedCallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Call inline function from AdditionModule
        AdditionModule::inline_addition(a, b)
    }
}



//# run 0xCAFE::NestedCallerModule::call_inline_add --args 15u8 20u8




//# run 0xCAFE::AdditionModule::add_and_return_sum --args 5u8 6u8



//# run 0xCAFE::AdditionModule::with_lambda --args 2u8 3u8
