
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use 0xCAFE::MyModule as M;

    // 1. Bind the complete value to a variable using an empty unpacking pattern
    public fun binding_test(): bool {
        let s = M::S {x: 123, y: 456};
        let () = s; // binding the entire value via empty pattern (simulate in Move)
        true
    }

    // 2. Generate a spec that omits reference types
    public fun spec_no_reference_types() {
        // Suppose `f3` is called with a value instead of reference
        let value: u16 = 42;
        M::f3(value);
    }

    // 3. Use a module alias to refer to resources or functions
    public fun alias_usage(signer_addr: address) {
        // Store a resource using the alias
        M::store_at_signer_address(signer::signer_ref(address=signer_addr), 9, 8);
        let (x, y) = M::inspect_value(signer::signer_ref(address=signer_addr));
        // Update values using the alias
        M::update_value(signer::signer_ref(address=signer_addr), 7, 6);
        // Remove the resource using alias module
        M::remove_at_signer_address(signer::signer_ref(address=signer_addr));
    }

    // Spec function to abstract away reference handling
    public fun spec_function_without_refs(x: u16): u16 {
        // simply call f2 with a value, ignoring references
        let (a, b) = M::f2(x);
        a + b
    }
}


//# run 0xCAFE::TestModule::binding_test --args

//# run 0xCAFE::TestModule::spec_no_reference_types

//# run 0xCAFE::TestModule::alias_usage --signers 0xDADA

//# run 0xCAFE::TestModule::spec_function_without_refs --args 100u16

// Featurres:
// 4b9b9b63a27bc5bc5ac5d711e8b686bf: Bind the complete value to a variable using an empty unpacking pattern (i.e., `Name {}` or `Name ()`)
// 106a2bb706ab7fa01d829d1a39612d4a: Automatically generate specification functions that omit reference types in parameter and return types, abstracting away references in specs.
// 0bfe0ae9eb5d9bbba8d0f4ec9cb136c1: Use a module alias to refer to resources or functions defined in another module.
