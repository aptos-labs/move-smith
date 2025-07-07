//# publish
module 0xDEAD::KeyFeaturesTestModule {
    // This module contains functions to test key Move features as described.

    // Struct with copy and drop abilities
    struct TestCopyDrop has copy, drop {
        value: u64
    }

    // Struct with only store ability, no copy or drop
    struct NonCopyDropStruct has store {
        num: u64
    }

    // Internal function to verify access restrictions
    fun internal_verify_access() {
        // inside module, accessible
        let _s = TestCopyDrop { value: 42 };
        let _n = NonCopyDropStruct { num: 7 };
    }

    // Expose a script entry point to execute internal access check
    public fun run_internal_access_check() {
        internal_verify_access();
    }

    // Function to create, clone, and drop TestCopyDrop
    public fun test_copy_drop_behavior(val: u64): (TestCopyDrop, TestCopyDrop) {
        let original = TestCopyDrop { value: val };
        // Clone (by copying)
        let clone = original;
        // Drop original is implicit after this point
        (original, clone)
    }

    // Function to create and do some operations with NonCopyDropStruct
    public fun test_non_copy_drop_struct() {
        let s = NonCopyDropStruct { num: 10 };
        // Can move but not clone
        let moved_s = s;
        // Correct way to avoid compile error: remove move_from in test
        move_from<NonCopyDropStruct>(&moved_s.num);
        // Alternatively, do something else or just leave as is.
    }

    // Function to test a function with 65 arguments
    public fun high_arg_function(
        a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8, a10: u8,
        a11: u8, a12: u8, a13: u8, a14: u8, a15: u8, a16: u8, a17: u8, a18: u8, a19: u8, a20: u8,
        a21: u8, a22: u8, a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8, a30: u8,
        a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8, a40: u8,
        a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8, a48: u8, a49: u8, a50: u8,
        a51: u8, a52: u8, a53: u8, a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8, a60: u8,
        a61: u8, a62: u8, a63: u8, a64: u8, a65: u8
    ): u64 {
        // Sum all arguments and return the total as u64
        a1 as u64 + a2 as u64 + a3 as u64 + a4 as u64 + a5 as u64 +
        a6 as u64 + a7 as u64 + a8 as u64 + a9 as u64 + a10 as u64 +
        a11 as u64 + a12 as u64 + a13 as u64 + a14 as u64 + a15 as u64 +
        a16 as u64 + a17 as u64 + a18 as u64 + a19 as u64 + a20 as u64 +
        a21 as u64 + a22 as u64 + a23 as u64 + a24 as u64 + a25 as u64 +
        a26 as u64 + a27 as u64 + a28 as u64 + a29 as u64 + a30 as u64 +
        a31 as u64 + a32 as u64 + a33 as u64 + a34 as u64 + a35 as u64 +
        a36 as u64 + a37 as u64 + a38 as u64 + a39 as u64 + a40 as u64 +
        a41 as u64 + a42 as u64 + a43 as u64 + a44 as u64 + a45 as u64 +
        a46 as u64 + a47 as u64 + a48 as u64 + a49 as u64 + a50 as u64 +
        a51 as u64 + a52 as u64 + a53 as u64 + a54 as u64 + a55 as u64 +
        a56 as u64 + a57 as u64 + a58 as u64 + a59 as u64 + a60 as u64 +
        a61 as u64 + a62 as u64 + a63 as u64 + a64 as u64 + a65 as u64
    }

    // Function to invoke high_arg_function directly
    public fun call_high_arg_function_direct(): u64 {
        high_arg_function(
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
            31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
            51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
            61, 62, 63, 64, 65
        )
    }

    // Function to invoke high_arg_function via a closure
    public fun call_high_arg_function_via_closure(): u64 {
        let closure = |a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8, a10: u8,
                        a11: u8, a12: u8, a13: u8, a14: u8, a15: u8, a16: u8, a17: u8, a18: u8, a19: u8, a20: u8,
                        a21: u8, a22: u8, a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8, a30: u8,
                        a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8, a40: u8,
                        a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8, a48: u8, a49: u8, a50: u8,
                        a51: u8, a52: u8, a53: u8, a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8, a60: u8,
                        a61: u8, a62: u8, a63: u8, a64: u8, a65: u8
        ): u64 {
            high_arg_function(
                a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,
                a11, a12, a13, a14, a15, a16, a17, a18, a19, a20,
                a21, a22, a23, a24, a25, a26, a27, a28, a29, a30,
                a31, a32, a33, a34, a35, a36, a37, a38, a39, a40,
                a41, a42, a43, a44, a45, a46, a47, a48, a49, a50,
                a51, a52, a53, a54, a55, a56, a57, a58, a59, a60,
                a61, a62, a63, a64, a65
            )
        };
        closure(
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
            31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
            51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
            61, 62, 63, 64, 65
        )
    }

    // Schema type registration: define a schema with type parameters
    struct MySchema<T>(T) has copy, drop, key {}

    // Test schema registration
    public fun register_schema() {
        let schema_instance = MySchema::<u64>(12345);
        // Schema info accessible within module
        let _ = schema_instance;
    }
}
