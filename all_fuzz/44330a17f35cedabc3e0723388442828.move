
//# publish
module 0xCAFE::Adder {
    // Test addition of two u8 values and return a fixed u8 value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        // Return a fixed value 42u8 ignoring the sum result
        42u8
    }

    // Function with lambda: accepts a lambda that takes two u8 and returns u8,
    // applies the lambda to (a, b), then returns the result plus 1
    public fun apply_lambda_plus_one(a: u8, b: u8, f: |u8, u8|u8): u8 {
        let result = f(a, b);
        result + 1
    }

    // Declare a struct with several abilities with commas for testing parsing abilities list
    struct HasAbilities has store, drop, copy {
        x: u8
    }
}



//# run 0xCAFE::Adder::add_and_return_fixed --args 10u8 25u8



//# run 0xCAFE::Adder::apply_lambda_plus_one --args 3u8 4u8



//# publish
module 0xCAFE::LambdaTest {
    use 0xCAFE::Adder;

    public fun lambda_add(a: u8, b: u8): u8 {
        // Create a lambda that adds two u8
        let my_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        // Use Adder module's function which applies f and adds 1
        Adder::apply_lambda_plus_one(a, b, my_lambda)
    }
}



//# run 0xCAFE::LambdaTest::lambda_add --args 5u8 7u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Adder;

    public fun call_inline_addition(a: u16): u16 {
        // Call a nested inline function declared below:
        // 1) First calls add_one_inline which returns a+1
        // 2) Then call add_two_inline which calls add_one_inline and adds 1 more
        let res = add_two_inline(a);
        res
    }

    public inline fun add_one_inline(x: u16): u16 {
        x + 1
    }

    public inline fun add_two_inline(y: u16): u16 {
        let a = add_one_inline(y);
        a + 1
    }
}



//# run 0xCAFE::InlineCaller::call_inline_addition --args 99u16



//# publish
module 0xCAFE::FeatureFlags {
    use std::signer;

    // Declare a struct to store the bitset of enabled features
    struct Flags has key, store {
        bits: u64
    }

    const FEATURE_1: u64 = 1 << 0;
    const FEATURE_2: u64 = 1 << 1;
    const FEATURE_3: u64 = 1 << 2;

    // Initialize with no features enabled
    public fun init(s: signer) {
        let address = signer::address_of(&s);
        assert!(!exists<Flags>(address), 100);
        let flags = Flags { bits: 0 };
        move_to<Flags>(&s, flags);
    }

    // Enable a specific feature bit while leaving others as is
    public fun enable_feature(s: signer, feature_bit: u64) {
        let address = signer::address_of(&s);
        assert!(exists<Flags>(address), 101);
        let flags_ref = borrow_global_mut<Flags>(address);
        flags_ref.bits = flags_ref.bits | feature_bit;
    }

    // Disable a specific feature bit
    public fun disable_feature(s: signer, feature_bit: u64) {
        let address = signer::address_of(&s);
        assert!(exists<Flags>(address), 102);
        let flags_ref = borrow_global_mut<Flags>(address);
        flags_ref.bits = flags_ref.bits & !feature_bit;
    }

    // Check if feature is enabled
    public fun is_feature_enabled(address: address, feature_bit: u64): bool {
        if (!exists<Flags>(address)) {
            false
        } else {
            let flags_ref = borrow_global<Flags>(address);
            (flags_ref.bits & feature_bit) != 0
        }
    }

    // Enable only FEATURE_2 and ensure others are disabled after
    public fun enable_only_feature_2(s: signer) {
        let address = signer::address_of(&s);
        assert!(exists<Flags>(address), 110);
        let flags_ref = borrow_global_mut<Flags>(address);
        // Clear all bits except FEATURE_2
        flags_ref.bits = FEATURE_2;
    }
}



//# run 0xCAFE::FeatureFlags::init --signers 0xBEEF



//# run 0xCAFE::FeatureFlags::enable_feature --signers 0xBEEF --args 1u64



//# run 0xCAFE::FeatureFlags::enable_feature --signers 0xBEEF --args 2u64



//# run 0xCAFE::FeatureFlags::enable_only_feature_2 --signers 0xBEEF



//# run 0xCAFE::FeatureFlags::is_feature_enabled --args 0xBEEF 1u64



//# run 0xCAFE::FeatureFlags::is_feature_enabled --args 0xBEEF 2u64



//# run 0xCAFE::FeatureFlags::is_feature_enabled --args 0xBEEF 4u64
