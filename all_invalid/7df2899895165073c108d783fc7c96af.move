
//# publish
module 0xCAFE::AbilityTest {
    use std::debug;

    // Structs with various ability combinations

    struct S1 has store {
        a: u8
    }

    struct S2 has copy, store {
        b: u16
    }

    struct S3 has drop, store {
        c: bool
    }

    struct S4 has copy, drop, store, key {
        d: u32
    }

    // Function that takes a type parameter with store ability only
    public fun fn_store_only<T: store>(x: T) {
        debug::print(b"fn_store_only called\n");
        let _copy_x = x; // We can only assume store, no copy, so this moves x
        // no further usage to avoid move errors
    }

    // Function requiring copy ability on T, with a value argument of type T
    public fun fn_copy_required<T: copy>(x: T) {
        debug::print(b"fn_copy_required called\n");
        let _y = x;     // copy x
        let _z = x;     // copy x again
    }

    // Function requiring drop ability on T, with a value argument of type T
    public fun fn_drop_required<T: drop>(x: T) {
        debug::print(b"fn_drop_required called\n");
        // Drop can be used implicitly, so no special code needed here
        let _temp = x; // Move in, drop will occur when out of scope
    }

    // Function requiring copy+drop+store abilities on T, takes T by value
    public fun fn_copy_drop_store<T: copy + drop + store>(x: T) {
        debug::print(b"fn_copy_drop_store called\n");
        let _a = x; // copy
        let _b = x; // copy again
        // x dropped after function ends
    }

    // Function requiring key ability on T
    public fun fn_key_required<T: key>(addr: address, x: T) {
        debug::print(b"fn_key_required called\n");
        move_to<T>(&signer::borrow_signer(addr), x);
        // The move_to would require key ability on T
    }

    // Runner function that calls all above functions multiple times
    public fun test_all_abilities(addr: address) {
        let s1 = S1 {a: 11};
        let s2 = S2 {b: 22};
        let s3 = S3 {c: true};
        let s4 = S4 {d: 44};

        // Call fn_store_only multiple times with s1 and s3 (both store only or with drop)
        fn_store_only<S1>(s1);
        let s1_2 = S1 {a: 111};
        fn_store_only<S1>(s1_2);

        fn_store_only<S3>(s3);
        let s3_2 = S3 {c: false};
        fn_store_only<S3>(s3_2);

        // Call fn_copy_required multiple times with s2 and s4
        fn_copy_required<S2>(s2);
        let s2_2 = S2 {b: 222};
        fn_copy_required<S2>(s2_2);

        fn_copy_required<S4>(s4);
        let s4_2 = S4 {d: 444};
        fn_copy_required<S4>(s4_2);

        // Call fn_drop_required multiple times with s3 and s4
        let s3a = S3 {c: true};
        fn_drop_required<S3>(s3a);
        let s3b = S3 {c: false};
        fn_drop_required<S3>(s3b);

        let s4a = S4 {d: 4};
        fn_drop_required<S4>(s4a);
        let s4b = S4 {d: 5};
        fn_drop_required<S4>(s4b);

        // Call fn_copy_drop_store multiple times with s4
        let s4c = S4 {d: 7};
        fn_copy_drop_store<S4>(s4c);
        let s4d = S4 {d: 8};
        fn_copy_drop_store<S4>(s4d);

        // Create an S4 instance for key test and call fn_key_required
        let instance = S4 {d: 12345};
        fn_key_required<S4>(addr, instance);
    }
}


//# run 0xCAFE::AbilityTest::test_all_abilities --signers 0xBEEF


// Featurres:
// ee27efda6f6e574dce0f4c91b0f6c551: Call built-in functions using explicit type arguments and regular argument lists.
// 737856b5e405835319fb4a3052281bdf: Invoke the function multiple times to ensure logging is configured without errors.
// 04a0c8595d70719671ccf6bc64624606: Declare type abilities (such as 'copy', 'drop', 'store', or 'key') using the 'has' keyword on structs
