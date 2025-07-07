
//# publish
module 0xCAFE::TestModule1 {
    // Define a public resource with abilities
    struct ResourceStruct has key, store {  
        value: u64,
    }

    // Function that successfully publishes a resource
    public fun publish_resource(account: &signer, val: u64) {
        move_to(account, ResourceStruct { value: val });
    }

    // Specification function for publish_resource
    public fun $publish_resource(account: &signer, val: u64) {
        publish_resource(account, val);
    }

    // Function that attempts to publish a resource with invalid abilities (simulate Bytecode Verification Error)
    public fun invalid_publish(account: &signer, val: u64) {
        // intentionally missing abilities to cause a verification error
        // Note: In real code, abilities are fixed at struct definition; here, we simulate the error by incorrect usage
        move_to(account, ResourceStruct { value: val });
    }

    // Specification function for invalid_publish
    public fun $invalid_publish(account: &signer, val: u64) {
        invalid_publish(account, val);
    }
}



//# run 0xCAFE::TestModule1::publish_resource --signers 0xBEEF --args 42u64



//# run 0xCAFE::TestModule1::invalid_publish --signers 0xBEEF --args 42u64



//# publish
module 0xCAFE::TestSandbox {
    // Function that calls a non-existent function in a module (to generate bytecode verification error)
    public fun trigger_invalid_code() {
        // Call a non-existent function to cause verification error
        // "NonExistentModule" is not defined
        NonExistentModule::some_function();
    }
}



//# run 0xCAFE::TestSandbox::trigger_invalid_code