//# publish
module 0x1::TestModule {
    // Use a module key with optional address and module name
    public fun create_resource(account: &signer) {
        move_to(account, Resource { data: 42 });
    }

    // Function to retrieve resource data (for potential tests)
    public fun get_resource_data(addr: address) acquires Resource {
        let resource_ref = borrow_global<Resource>(addr);
        resource_ref.data
    }

    // Function to be called as a runner
    public fun run_tests() {
        // Placeholder for internal test logic if needed
    }

    // Struct definition to test labels in diagnostics
    //@ label: Resource Struct
    struct Resource {
        data: u64,
    }
}

//# run 0x1::TestModule::run_tests --signers 0xA550 --args