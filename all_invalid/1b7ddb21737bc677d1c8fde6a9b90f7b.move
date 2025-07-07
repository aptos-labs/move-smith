
//# publish
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
        // Should compile if ability enforcement is correct
        let res_ref: &PrivResource = borrow_global<PrivResource>(signer::address_of(s));
        res_ref.pub_field
    }

    // Function attempting to mutate resource with only read ability
    public fun attempt_borrow_global_mut(s: &signer): &mut PrivResource acquires PrivResource {
        // Should fail if move semantics constrain ability (but in code, this is compile time)
        borrow_global_mut<PrivResource>(signer::address_of(s))
    }
}


//# run 0xCAFE::NegativeAbilityTest::publish_resource --signers 0xBEEFCACE


//# run 0xCAFE::NegativeAbilityTest::attempt_borrow_global --signers 0xBEEFCACE


//# run 0xCAFE::NegativeAbilityTest::attempt_borrow_global_mut --signers 0xBEEFCACE



//# publish
module 0xCAFE::TypeWithParenthesis {
    use std::signer;

    // Struct with tuple and resource inside parentheses
    struct PResource has key {
        (a: u8, b: u8): (u8, u8),
        resource_field: PrivResource,
    }

    resource PrivResource {
        x: u64,
    }

    public fun create_p_resource(s: &signer): PResource {
        let inner_res = PrivResource { x: 12345 };
        PResource {
            (a: 1, b: 2),
            resource_field: inner_res,
        }
    }

    public fun access_fields(p: &PResource) : u64 {
        p.resource_field.x
    }

    public fun get_tuple(p: &PResource): (u8, u8) {
        p.(a, b)
    }
}


//# run 0xCAFE::TypeWithParenthesis::create_p_resource --signers 0xDADDCAFE


//# run 0xCAFE::TypeWithParenthesis::access_fields --signers 0xDADDCAFE --args


//# run 0xCAFE::TypeWithParenthesis::get_tuple --signers 0xDADDCAFE



//# publish
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


//# run 0xCAFE::RemoveBytecodeDependency::remove_dependency_files


//# run 0xCAFE::RemoveBytecodeDependency::verify_no_dependency_files

// Featurres:
// 7c1d99aad727aee08a66a4873aae3d23: Test that negative ability constraints like !reads on function visibility modifiers are properly enforced and interpreted when accessing resources with borrow_global.
// d76b9ce10a67c45edb4d1950c476495c: Start a type with an opening parenthesis '(' or an ampersand '&' or '& mut' for mutable references.
// 9b47cf51351f3a28b90ef53be117eb6e: Remove bytecode files from the list of dependencies after generating interface files.
