//# publish
module 0x55::resource_borrow_test {
    struct GlobalResource has key {
        owner: address,
        value: u64,
    }

    fun init(owner: &signer, val: u64) {
        move_to(owner, GlobalResource { owner: signer::address_of(owner), value: val });
    }
}

//# publish
module 0x55::test {
    use 0x55::resource_borrow_test;
    use std::signer;

    // Helper function to initialize a resource at a given address
    fun setup_resource(addr: address, val: u64) {
        // Create a dummy signer for the target address via impersonation
        // Since Move tests run with test signers, simulate by calling init directly.
        // In actual test environment, this might involve more setup.
        // For simplicity, assume the init function is called with a signer that represents `addr`.
        // Here, we call init with a signer of that address.
        // Note: In real tests, you'd have predefined signers for addresses.
    }

    //# run --signers 0xA -- 0x55::resource_borrow_test::init --args 0xA 100
    //# run --signers 0xB -- 0x55::resource_borrow_test::init --args 0xB 200

    // Set up resources at different signers
    //# run --signers 0xA -- 0x55::resource_borrow_test::init --args 0xA 100
    //# run --signers 0xB -- 0x55::resource_borrow_test::init --args 0xB 200

    // Test borrowing from the correct owner with various address specifiers
    //# run 0x55::test::borrow_global_resource_0xA --signers 0xA --args @0xA
    //# run 0x55::test::borrow_global_resource_0xA_star --signers 0xA --args @0xA
    //# run 0x55::test::borrow_global_resource_all --signers 0xA --args @0xA

    // Attempt to borrow from the wrong owner, should fail
    //# run 0x55::test::borrow_global_resource_wrong_owner --signers 0xA --args @0xB
    //# run 0x55::test::borrow_global_resource_wrong_owner_star --signers 0xA --args @0xB

}

//# run --verbose --signers 0xA -- 0x55::test::borrow_global_resource_0xA
//# run --verbose --signers 0xA -- 0x55::test::borrow_global_resource_0xA_star
//# run --verbose --signers 0xA -- 0x55::test::borrow_global_resource_all
//# run --verbose --signers 0xA -- 0x55::test::borrow_global_resource_wrong_owner
//# run --verbose --signers 0xA -- 0x55::test::borrow_global_resource_wrong_owner_star