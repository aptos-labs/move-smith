
//# publish
module 0xCAFE::RenamingAndPhantomTest {
    use std::signer as SignerAlias;

    // Component 1: Test importing with 'use as', verifying accessibility and functionality.
    // It imports the `std::signer` module as `SignerAlias` and provides a wrapper function to call `address_of`.
    public fun get_signer_address(s: SignerAlias::signer): address {
        SignerAlias::address_of(&s)
    }

    // Component 2: Define a struct with type parameters, marking some as phantom.
    // The 'is_phantom' attribute indicates the type parameter is phantom.
    struct GenericStruct<T, U> has copy, drop, store {
        value: u64,
        _phantom: phantom<mark T, U>,
    }

    // Helper function to create a generic struct instance with specific types.
    public fun create_generic_struct<T, U>(val: u64): GenericStruct<T, U> {
        let gen_struct = GenericStruct<T, U> { value: val, _phantom: phantom<mark T, U> };
        gen_struct
    }

    // Function that takes a generic struct with phantom type parameters and does a simple check
    public fun use_generic_struct<T, U>(gs: &GenericStruct<T, U>) {
        let v = gs.value;
        // Use the value to verify runtime behavior (no impact from phantom)
        assert!(v >= 0, 123);
    }

    // Component 3: Use labels and jumps in a function combining control flow.
    public fun control_flow_with_labels(flag: bool): u8 {
        // Declare labels
        label start;
        label branch_true;
        label branch_false;
        label after;

        goto start;

        // Start label
        start:
            if (flag) {
                goto branch_true;
            } else {
                goto branch_false;
            }
        // True branch label
        branch_true:
            let _ = 1u8;
            goto after;

        // False branch label
        branch_false:
            let _ = 2u8;
            goto after;

        // After label
        after:
            // Final computation
            if (flag) {
                100u8
            } else {
                200u8
            }
    }

    // Combined function testing import aliasing, phantom types, and labels
    public fun combined_test(s: SignerAlias::signer, flag: bool): (address, u64, u8) {
        // Use imported 'SignerAlias' to get address
        let addr = get_signer_address(s);

        // Create a generic struct with phantom types
        let gs: GenericStruct<bool, u8> = create_generic_struct<bool, u8>(42);
        use_generic_struct<bool, u8>(&gs);

        // Call control flow with labels
        let result_value = control_flow_with_labels(flag);
        (addr, gs.value, result_value)
    }
}

//# run 0xCAFE::RenamingAndPhantomTest::combined_test --signers 0xBADD --args 0xBADD  true


// Featurres:
// 1d1a21ecdc95d0207d820dc1a7ad9c57: Rename an imported module or member using the 'as' keyword in 'use' statements.
// 442e0dcdfd33d8af2b7856544d547ff0: Mark struct type parameters as phantom using is_phantom
// 33d2256708c8f2c0dc85490da48fef02: Define labels at specific points in code to mark positions for jumps and control flow management.
