
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // Removed lambda expression (unsupported in Move)
    public fun lambda_example(x: u8, y: u8): u8 {
        // Instead of lambda, just directly return sum
        x + y
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun compound_statements(x: u8, y: u8): u8 {
        {
            let z = x + 1;
            let w = y + 2;
            let r = z + w;
            r
        }
    }

    public fun match_example(e: u8): u8 {
        // Move currently does not support `match` expressions directly.
        // Use `if-else` chains instead.
        if (e == 0) {
            10
        } else if (e == 1) {
            20
        } else {
            30
        }
    }
}




//# run 0xCAFE::AddModule::add_and_return_sum --args 5u8 7u8




//# run 0xCAFE::AddModule::lambda_example --args 3u8 8u8




//# run 0xCAFE::AddModule::compound_statements --args 2u8 3u8




//# run 0xCAFE::AddModule::match_example --args 1u8




//# publish
module 0xCAFE::CallInlineModule {
    // Correct the address from 0xCAFE to the current module's published address if necessary.
    // But since both are 0xCAFE, keep it as-is.

    use 0xCAFE::AddModule;

    public fun call_inline(a: u8, b: u8): u8 {
        // Calling inline function within braces
        {
            let result = AddModule::inline_adder(a, b);
            result
        }
    }
}




//# run 0xCAFE::CallInlineModule::call_inline --args 9u8 4u8
