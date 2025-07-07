//# publish
module 0xA550C83A12345678::spec_test_module {
    // Module with specifications annotations
    /// Use: This module is used for testing Specs and Uses annotations
    resource struct TestResource {
        value: u64,
    }

    /// Spec: A function to create a TestResource
    public fun create_resource(account: &signer, init_value: u64) {
        move_to(account, TestResource { value: init_value });
    }

    /// Use: Function to get the resource's value
    public fun get_resource_value(account: address): u64 acquires TestResource {
        let resource = borrow_global::<TestResource>(account);
        resource.value
    }

    // Struct with optional visibility modifiers (simulate visibility control)
    // Note: Visibility modifiers are only allowed when language v2 is enabled
    // (In Move, visibility is specified via 'public', 'public(foo)', or private by default)
    // Here, we declare some structs with optional visibility modifiers
    // Assuming in language v2, visibility types are allowed
    // For this test, we will declare a struct with and without visibility
    pub struct VisibleStruct {
        pub field: u64,
    }

    struct HiddenStruct {
        field: u64,
    }

    // Configure error reporting to output errors to a specified writer
    // (This is hypothetical; in actual Move, error reporting configuration may vary)
    // For the purpose of this test, we assume a function to set error output
    public fun configure_error_reporting(writer_address: address) {
        // Pseudo-code: set error output writer
        // set_error_output(writer_address);
        // Since Move doesn't have direct error output configuration in code,
        // this is a placeholder to simulate the feature.
    }
}

//# run 0xA550C83A12345678::spec_test_module::create_resource --signers 0x1 --args 42u64
//# run 0xA550C83A12345678::spec_test_module::get_resource_value --args 0x1