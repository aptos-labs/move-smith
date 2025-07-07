
//# publish
module 0xDEAD::BorrowingTests {
    use std::vector;
    use std::signer;
    use std::error;

    struct TestResource has store, key {
        value: u64,
    }

    public fun publish_resource(s: signer, v: u64) {
        move_to<TestResource>(&s, TestResource {value: v});
    }

    public fun borrow_global_resource(address: address): &TestResource acquires TestResource {
        borrow_global<TestResource>(address)
    }

    public fun borrow_global_resource_mut(address: address): &mut TestResource acquires TestResource {
        borrow_global_mut<TestResource>(address)
    }

    public fun remove_resource(address: address) {
        move_from<TestResource>(address);
    }

    // Helper to test borrowing at specific address and expected success/failure
    public fun test_borrow(address: address, should_succeed: bool) {
        // We expect success or failure based on should_succeed
        if (should_succeed) {
            let _res_ref = borrow_global_resource(address);
        } else {
            // For invalid borrow, simulate with error checking
            error::assert_or_error(borrow_global_resource(address), error::INTERNAL);
        };
    }

    // Helper to test mutable borrow at address
    public fun test_borrow_mut(address: address, should_succeed: bool) {
        if (should_succeed) {
            let res_mut_ref = borrow_global_resource_mut(address);
            res_mut_ref.value = res_mut_ref.value + 1;
        } else {
            error::assert_or_error(borrow_global_resource_mut(address), error::INTERNAL);
        };
    }

    // Get the static set of built-in type names
    public fun get_builtin_type_names(): &vector<vector<u8>> {
        // Placeholder for static set; in a real scenario, this could be a static reference
        &vector[
            b"u8",
            b"u64",
            b"bool",
            b"address",
            b"vector"
        ]
    }

    // Handle condition kinds
    public fun handle_conditions() {
        // Example of various condition expressions
        if (true) {
            let _ = 1u8;
        } else {
            let _ = 2u8;
        };

        if (false) {
            let _ = 3u8;
        } else if (true) {
            let _ = 4u8;
        } else {
            let _ = 5u8;
        };

        let x = if (true) {
            10u8
        } else {
            20u8
        };

        // Nested condition
        if (x > 0) {
            if (x < 10) {
                let _ = x + 1;
            };
        };
    }
}


//# run 0xDEAD::BorrowingTests::publish_resource --signers 0xBADA --args 42u64


//# run 0xDEAD::BorrowingTests::test_borrow --args 0xBADA --signers 0xBADA --args 0x0000000000000000 --args false


//# run 0xDEAD::BorrowingTests::test_borrow --args 0xCAFE --signers 0xBADA --args 0x0000000000000000 --args true


//# run 0xDEAD::BorrowingTests::test_borrow_mut --args 0xBADA --signers 0xBADA --args 0x0000000000000000 --args false


//# run 0xDEAD::BorrowingTests::test_borrow_mut --args 0xCAFE --signers 0xBADA --args 0x0000000000000000 --args true


//# run 0xDEAD::BorrowingTests::get_builtin_type_names


//# run 0xDEAD::BorrowingTests::handle_conditions


// Featurres:
// f0cf181c34dcf3ea3d175b4994a94dce: Test that borrowing a global resource with various valid and invalid address specifications correctly succeeds or fails according to the address scope and ownership rules.
// 8a179fa2700dc8ec1d5a56648cc1defd: Retrieve the 'BUILTIN_TYPE_NAMES' set as a static reference, enabling efficient lookups of built-in type names within Move code.
// 2f07a7ea3987fab4a3e393e891cbfae1: Define condition blocks with specific kinds, properties, expressions, and optional aliases.
