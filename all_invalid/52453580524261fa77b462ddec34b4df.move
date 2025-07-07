
//# publish
module 0xCAFE::TestFeatureVariants {
    use std::vector;

    struct PhantomStruct<T> has copy, drop, store {
        value: u64,
        phantom: T,
    }

    // Function with a native body, assuming Move supports native declarations
    public fun native_body_func(x: u64): u64;
    // Mark for native implementation (simulated here as an inline for test purposes)
    // In actual tests, this could be replaced with a real native or external function

    // Function with inline body
    public inline fun inline_body_func(x: u64): u64 {
        x + 42
    }

    // Function with a normal body, using all control flow branches
    public fun control_flow_test(v: u8): u8 {
        let result: u8;
        if (v > 10) {
            result = 1;
        } else if (v == 10) {
            result = 2;
        } else {
            result = 3;
        };
        result
    }

    // Function demonstrating that a variable declared but not initialized in all branches
    public fun early_return_test(flag: bool): u8 {
        let value: u8;
        if (flag) {
            return 100u8;
        } else {
            value = 42;
        };
        // The variable 'value' is only initialized if 'flag' is false,
        // trying to use it after the early return should fail (test compiler validation)
        value
    }

    // Function that uses a struct with phantom data
    public fun create_phantom_struct<T>(): PhantomStruct<T> {
        PhantomStruct { value: 999u64, phantom: core::marker::PhantomData }
    }

    // Function that explicitly calls the native function (simulated)
    public fun call_native_func(x: u64): u64 {
        // In actual test, this would call an external/native function
        // For test purposes, emulate calling the inline version
        inline_body_func(x)
    }

    // Runner function to test various features
    public fun test_all() {
        // Call inline function
        let _ = inline_body_func(10);
        // Call native function
        let _ = call_native_func(20);
        // Create struct with phantom data
        let _ = create_phantom_struct<u8>();
        // Control flow test with different inputs
        let _ = control_flow_test(15);
        let _ = control_flow_test(10);
        let _ = control_flow_test(5);
        // Early return test with flag true (should abort / not reach after)
        let _ = early_return_test(true);
        // Early return test with flag false
        let _ = early_return_test(false);
    }
}



//# run 0xCAFE::TestFeatureVariants::test_all

// Features:
// cb2d48b351c3c55b97a8fc4ba45e4001: Use different function body types, such as defined or native, with appropriate validation.
// 26223f9b709fad2569f39f8ec1cf05a9: Test that a variable declared but not initialized in all control flow branches cannot be used after an early return.
// 1e4ea42b70714ed824d356f20e055e8f: Specify type parameters with phantom declarations in struct definitions.