module 0xCAFE::NegativeAbilityTest {
    use std::signer;

    // Resource with public and private fields
    struct PrivResource has key {
        pub_field: u64,
        priv_field: u64,
    }

    // Function to publish resource under signer
    public fun publish_resource(s: &signer) {
        let res = PrivResource { pub_field: 42, priv_field: 99 };
        move_to<PrivResource>(s, res);
    }

    // Function attempting read of resource with no ability to read (simulate access)
    // Normally, borrow_global requires `read` ability, so this will enforce ability constraints
    public fun attempt_borrow_global(s: &signer): u64 acquires PrivResource {
        // borrow_global returns a reference, which is valid here
        let res_ref: &PrivResource = borrow_global<PrivResource>(signer::address_of(s));
        res_ref.pub_field
    }

    // Function attempting to mutate resource with only read ability
    public fun attempt_borrow_global_mut(s: &signer): &mut PrivResource acquires PrivResource {
        // borrow_global_mut returns a mutable reference; it requires the caller to have the ability
        // but the major issue in the original code was using &signer, which is fine. 
        // The actual compile-time constraints are enforced by the ability annotations.
        borrow_global_mut<PrivResource>(signer::address_of(s))
    }
}

module 0xCAFE::TypeWithParenthesis {
    use std::signer;

    // Struct with tuple and resource inside parentheses, fixed syntax
    struct PResource has key {
        a_b: (u8, u8),
        resource_field: PrivResource,
    }

    resource PrivResource {
        x: u64,
    }

    public fun create_p_resource(s: &signer): PResource {
        let inner_res = PrivResource { x: 12345 };
        PResource {
            a_b: (1, 2),
            resource_field: inner_res,
        }
    }

    public fun access_fields(p: &PResource): u64 {
        p.resource_field.x
    }

    public fun get_tuple(p: &PResource): (u8, u8) {
        p.a_b
    }
}

module 0xCAFE::RemoveBytecodeDependency {
    // No struct or resource, just functions to simulate dependency removal
    public fun remove_dependency_files() {
        // In actual tests, this would remove bytecode dependency files
        // Simulation: just a placeholder
    }

    public fun verify_no_dependency_files() {
        // In actual test, verify dependency files are absent
        // Simulate with no-op
    }
}