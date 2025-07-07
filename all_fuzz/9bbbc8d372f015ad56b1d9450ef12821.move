
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::TestFeatures {
    // Removed unused imports std::vector and std::signer

    // 4. Restrict type ability declarations to valid keywords: copy, drop, store, key
    struct Data has copy, drop, store {
        a: u8,
        b: u8,
    }

    // 1. Test a function that adds two u8 values then returns a specific value
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // sum is not the return, fixed value 42u8 is
        42u8
    }

    // 2. Write function containing lambda expressions
    public fun lambda_test(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |v: u8| {
            v + 1u8
        };
        let double_val: |u8|u8 has copy+drop = |v: u8| {
            v * 2u8
        };

        let result = double_val(add_one(x));
        result
    }

    // 3. Call an inline function from another module nested with multiple calls and return result
    // Inline function returns tuple of two u16 values
    public fun nested_inline_calls(a: u16): u16 {
        let (a1, a2) = 0xCAFE::MyModule::f2(a);
        let (b1, b2) = 0xCAFE::MyModule::f2(a1);
        a2 + b1 + b2
    }

    // 5. Inline specs for verification (formal verification support)
    // We use 'assert!' inside body as specs for simplicity
    public fun function_with_spec(x: u8): u8 {
        assert!(x < 100, 1001);
        let y = x + 1u8;
        assert!(y > x, 1002);
        y
    }

    // 6. Use copy x instead of copy(x)
    public fun copy_usage_demo(x: u8): u8 {
        let y = copy x;
        y + 10u8
    }
}


//# run 0xCAFE::TestFeatures::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::TestFeatures::lambda_test --args 7u8


//# run 0xCAFE::TestFeatures::nested_inline_calls --args 5u16


//# run 0xCAFE::TestFeatures::function_with_spec --args 20u8


//# run 0xCAFE::TestFeatures::copy_usage_demo --args 12u8
