
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // Example function required by NestedCalls::use_inline_from_other_module
        // Just return (a, a + 1)
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::NestedCalls {
    // Removed unused import
    // use std::signer;

    public fun add_u8(a: u8, b: u8): u8 {
        // Return sum of a and b plus 5 to distinguish from simple sum
        let sum = a + b;
        sum + 5
    }

    public fun lambda_example(val: u8): u8 {
        let l: |u8| u8 has copy+drop = |x: u8| {
            // multiply by 2 inside lambda
            x * 2
        };
        l(val)
    }

    public fun use_inline_from_other_module(a: u16): (u16, u16) {
        0xCAFE::MyModule::f2(a)
    }
}



//# run 0xCAFE::NestedCalls::add_u8 --args 10u8 20u8


//# run 0xCAFE::NestedCalls::lambda_example --args 15u8


//# run 0xCAFE::NestedCalls::use_inline_from_other_module --args 100u16
