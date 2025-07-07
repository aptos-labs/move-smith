
//# publish
module 0xFEED::TestModule {
    use std::vector;

    // Testing literal integers without suffix and their default type
    public fun test_literals() {
        let a = 123;         // Should infer as u8 or u64, depending on context, but default to u64 here
        let b = 456;         // Same as above
        let c = a + b;       // Use literals
        c
    }

    // Using index in tuple. For example, access the second element
    public fun test_tuple_index() {
        let t = (10u64, 20u64, 30u64);
        let second_element = *vector::borrow(&vector::singleton(0u8), 1);
        // The following is a direct indexing
        let (_first, second, _third) = t;
        second
    }

    // Using comma-separated literal values as standalone expressions
    public fun test_standalone_literals() {
        1u8;
        2u16;
        3u32;
        4u64;
        5u128;
        // These are standalone, and should not produce errors
        ()
    }

    // Combining different features: literals, tuple access, standalone expressions
    public fun test_combined_features() {
        let val1 = 100; // default to u64
        let val2 = 200; // default to u64
        let tuple = (val1, val2);
        let (x, y) = tuple;
        // Use index to access second tuple element
        let _ = y;
        // Use literal as standalone expression
        42;
        ()
    }
}



//# run 0xFEED::TestModule::test_literals



//# run 0xFEED::TestModule::test_tuple_index



//# run 0xFEED::TestModule::test_standalone_literals



//# run 0xFEED::TestModule::test_combined_features


// Featurres:
// 65a8053552ea57ed62634759f6bc35f0: Write integer literals without a type suffix to have them default to an untyped integer value.
// 1ec968b9866c644bfe28fd6c982f270e: Use numeric tokens to identify positional fields in Move code.
// 4cea096011321d0b7ad43823bd714ce1: Use literal values as standalone expressions
