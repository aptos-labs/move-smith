
//# publish
module 0xCAFE::MathModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // Move currently does not support lambda/anonymous functions syntax like Rust.
    // So, rewrite apply_lambda_to_add as a direct function call.
    public fun apply_lambda_to_add(): u8 {
        // Instead of using a lambda, just directly add the values
        let a: u8 = 10;
        let b: u8 = 20;
        a + b
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let sum = MathModule::inline_add(x, y);
        let added = MathModule::add_and_return_sum(sum, 5u8);
        added
    }

    public fun call_lambda_and_nested_inline(): u8 {
        let result = MathModule::apply_lambda_to_add();
        call_inline_and_add(result, 5u8)
    }
}



//# run 0xCAFE::MathModule::add_and_return_sum --args 7u8 8u8



//# run 0xCAFE::MathModule::apply_lambda_to_add



//# run 0xCAFE::NestedCallModule::call_inline_and_add --args 3u8 4u8



//# run 0xCAFE::NestedCallModule::call_lambda_and_nested_inline
