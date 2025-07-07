
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use 0xCAFE::MyModule as M;
    use 0x1::signer; // Assuming signer is in address 0x1, adjust if different

    // 1. Bind the complete value to a variable using an empty unpacking pattern
    public fun binding_test(): bool {
        let s = M::S {x: 123, y: 456};
        // Move the entire value into a variable (Move does not support empty patterns like in some languages)
        // So just binding the value directly
        let _temp = s;
        true
    }

    // 2. Generate a spec that omits reference types
    public fun spec_no_reference_types() {
        let value: u16 = 42;
        M::f3(value);
    }

    // 3. Use a module alias to refer to resources or functions
    public fun alias_usage(signer_addr: address) {
        let signer_ref = signer::signer_ref(&signer_addr);
        // Store a resource using the alias
        M::store_at_signer_address(&signer_ref, 9, 8);
        let (x, y) = M::inspect_value(&signer_ref);
        // Update values using the alias
        M::update_value(&signer_ref, 7, 6);
        // Remove the resource using alias module
        M::remove_at_signer_address(&signer_ref);
    }

    // Spec function to abstract away reference handling
    public fun spec_function_without_refs(x: u16): u16 {
        let (a, b) = M::f2(x);
        a + b
    }
}



//# run 0xCAFE::TestModule::binding_test --args


//# run 0xCAFE::TestModule::spec_no_reference_types


//# run 0xCAFE::TestModule::alias_usage --signers 0xDADA


//# run 0xCAFE::TestModule::spec_function_without_refs --args 100u16