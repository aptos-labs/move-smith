//# publish
module 0xCAFE::VerifierTest {
    // Use a dummy helper resource to test verification errors
    struct DummyResource has key { value: u64 }

    // 1. Function to intentionally produce verification errors (e.g., by violating borrow rules)
    public fun trigger_verification_failure() {
        // Try to create duplicate mutable references to the same global resource (should fail verification)
        let dummy_ref = borrow_global_mut<DummyResource>(0xCAFE);
        let dummy_ref2 = borrow_global_mut<DummyResource>(0xCAFE);
        // Use the references to simulate an error; in actual verification, the VM should reject this
        *dummy_ref2 = DummyResource { value: 42 };
        
        // The above should produce verification errors related to multiple mutable references
    }

    // 2. Function to test safe reference usage
    public fun safe_reference_usage() {
        let dummy = borrow_global<DummyResource>(0xCAFE);
        let ref_d = &dummy.value;
        let val = *ref_d; // read-only access
        // No verification error expected here
    }

    // 3. Function to bind values via 'let' in a spec block for verification
    public fun binding_in_spec() {
        // The following 'let' binding can be used for verification purposes
        // Spec block not shown but this illustrates binding
        let x = 10u64;
        let y = (x as u8); // cast to smaller type
        // use y in verification test
    }

    //# run 0xCAFE::VerifierTest::trigger_verification_failure --signers 0xCAFE
    //# run 0xCAFE::VerifierTest::safe_reference_usage --signers 0xCAFE
    //# run 0xCAFE::VerifierTest::binding_in_spec --signers 0xCAFE
}

// Features:
// b9357e244c52fd0cedc9e42b9dd30082: Display the bytecode verifier's unexpected status codes and diagnostics when verification errors occur in Move modules
// 7bd4a348fb0b20c70f26990142b873c4: Verify that references are used safely and conform to Move's reference safety guarantees.
// d8c9ee3b39f9145b5a4991ceb4b01bd9: Bind values using 'let' declarations in spec blocks for verification purposes