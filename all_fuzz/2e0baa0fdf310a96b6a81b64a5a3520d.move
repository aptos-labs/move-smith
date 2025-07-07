
//# publish
module 0xCAFE::InlineModule {
    // Inline function module

    // Inline function that returns (a+1, a-1) (note: the subtraction must not underflow, 
    // so a must be >= 1)
    public inline fun inline_add_and_sub(a: u16): (u16, u16) {
        (a + 1, a - 1)
    }
}



//# publish
module 0xCAFE::AddModule {
    // Module to test addition and lambda functions
    
    use 0xCAFE::InlineModule;

    // Performs addition of two u8 and returns sum + 1
    public fun add_and_return_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Lambda that adds two u8 and multiplies the result by 2
    public fun lambda_add_mul(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x + y) * 2
        };
        lambda(a, b)
    }

    // Calls the inline function from InlineModule and returns modified result
    public fun call_inline_and_transform(x: u16): u16 {
        let (a, b) = InlineModule::inline_add_and_sub(x);
        a + b + 10
    }
}



//# publish
module 0xCAFE::CallRewriter {
    // Simulate function call rewriting by wrapping add_and_return_plus_one
    
    use 0xCAFE::AddModule;

    // Wrapper function simulating rewritten call to AddModule::add_and_return_plus_one
    public fun rewritten_add_call(a: u8, b: u8): u8 {
        // For demonstration, we add 5 before calling and subtract 3 after calling
        let new_a = a + 5;
        let new_b = b + 5;
        let result = AddModule::add_and_return_plus_one(new_a, new_b);
        result - 3
    }
}



//# run 0xCAFE::AddModule::add_and_return_plus_one --args 10u8 20u8



//# run 0xCAFE::AddModule::lambda_add_mul --args 5u8 7u8



//# run 0xCAFE::AddModule::call_inline_and_transform --args 20u16



//# run 0xCAFE::CallRewriter::rewritten_add_call --args 10u8 10u8
