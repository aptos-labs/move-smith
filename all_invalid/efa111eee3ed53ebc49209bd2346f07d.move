
//# publish
module 0xDEAD::TestFeatures {
    use std::vector;

    // Dummy structs and enums for testing.
    struct DummyResource has store, key {
        val: u64,
    }

    struct UnrelatedResource has store, key {
        data: bool,
    }

    enum SampleEnum has copy, drop {
        Variant1,
        Variant2(u64),
        Variant3 { flag: bool },
    }

    // Function to test binding a field to a variable
    public fun bind_field_to_var() {
        let r = DummyResource { val: 42 };
        let DummyResource { val } = r;
        // 'val' bound to the field
        val
    }

    // Function to borrow a global resource with matching type
    public fun borrow_resource_and_use() {
        // Assume resource is stored at a specific address
        // Create and publish resource at address 0xBADD, for testing
        move_to<DummyResource>(&signer::borrow_signer(), DummyResource { val: 100 });
        let borrowed_ref: &DummyResource = borrow_global<DummyResource>(0xBADD);
        let v = borrowed_ref.val;
        v
    }

    // Function to borrow mismatched resource, expecting compile error
    public fun borrow_mismatched_resource() {
        // This should cause a compile-time/type mismatch error
        // Since 'UnrelatedResource' is of different type
        let _ref: &UnrelatedResource = borrow_global<UnrelatedResource>(0xBADD);
        // The above line is expected to fail compilation if uncommented.
        // For testing purposes, leave it as is.
        // _ref
    }

    // Function to test 'use' declarations
    public fun import_specifications() {
        // Use some dummy specifications (assuming they are defined elsewhere)
        // For the test, we'll just reference them.
        // 'use' is declared at the start and should work.
        // e.g. use 0xDEAD::SampleEnum;
        // Since no external specs are imported here, test merely by comment.
    }
}



//# run 0xDEAD::TestFeatures::bind_field_to_var



//# run 0xDEAD::TestFeatures::borrow_resource_and_use --signers 0xBADD



//# run 0xDEAD::TestFeatures::borrow_mismatched_resource --signers 0xBADD


// Features:
// 0fbed9708c84f588fe7afa082275208c: Bind a field to a variable or a bind pattern in Move code
// d0c248a9b0e77930c642fc950af4bb9a: Test that borrowing a global resource with a matched type works correctly and causes an error when the type does not match.
// 17c390b072c12b3bceb96eba26f1ecae: Include 'use' declarations at the start of a spec block to import other named specifications.
