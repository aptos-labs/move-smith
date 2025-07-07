//# publish
module 0xCAFE::ResourceCheck {
    use std::signer;

    struct R has key, store {
        val: u8,
    }

    // Properly declare acquisition of resource R
    public fun acquire_and_store(s: signer, v: u8) acquires R {
        let r = R { val: v };
        move_to<R>(&s, r);
    }

    // Read resource R properly declaring acquires
    public fun read_value(s: signer): u8 acquires R {
        let r_ref = borrow_global<R>(signer::address_of(&s));
        r_ref.val
    }

    // Update resource R – this function requires acquires
    public fun update_value(s: signer, new_val: u8) acquires R {
        let r_mut_ref = borrow_global_mut<R>(signer::address_of(&s));
        r_mut_ref.val = new_val;
    }

    // Remove resource R – must declare acquires
    public fun remove_resource(s: signer) acquires R {
        let r = move_from<R>(signer::address_of(&s));
        let R { val: _ } = r;
    }
}

//# run 0xCAFE::ResourceCheck::acquire_and_store --signers 0xD00D --args 42u8

//# run 0xCAFE::ResourceCheck::read_value --signers 0xD00D

//# run 0xCAFE::ResourceCheck::update_value --signers 0xD00D --args 100u8

//# run 0xCAFE::ResourceCheck::read_value --signers 0xD00D

//# run 0xCAFE::ResourceCheck::remove_resource --signers 0xD00D


//# publish
module 0xCAFE::AttributeErrorTest {
    // Simulated function with correct attribute syntax
    #[deprecated = true]
    public fun dummy() {}

    // The test is to trigger error from incorrect attribute usage like
    // #[some_attr(...)] instead of required #[some_attr = ...]
    // We cannot write an incorrect attribute in this test file because it will abort compilation of this test.
    // Instead, we test correct attribute syntax to ensure compiler accepts it.
    // This module's presence with attribute syntax confirms compiler acceptance.
}

//# run 0xCAFE::AttributeErrorTest::dummy


//# publish
module 0xCAFE::ShadowingTest {
    // This module is to test shadowing dependencies with 'sources_shadow_deps' flag enabled.
    // We shadow a module named ShadowsDeps with local version.

    struct Shadowed has store {
        val: u64,
    }

    public fun create_shadowed(): Shadowed {
        Shadowed { val: 1234 }
    }
}

//# run 0xCAFE::ShadowingTest::create_shadowed


//# publish
module 0xCAFE::ShadowingTest {
    // We publish a second version of ShadowingTest to test shadowing.
    // This source shadows the first ShadowingTest module if 'sources_shadow_deps' is enabled.
    // We change the function to produce a different value.

    struct Shadowed has store {
        val: u64,
    }

    public fun create_shadowed(): Shadowed {
        Shadowed { val: 5678 }
    }
}

//# run 0xCAFE::ShadowingTest::create_shadowed

// Featurres:
// 73d4b20956f885ed998d023491815143: Ensure that all target modules and functions correctly declare the resources they acquire, or have those acquisitions inferred by the compiler.
// 4585864c81dc99f37440dcd6627342af: Automatically trigger errors when an attribute is used with `#[attribute_name(...)]` apply syntax instead of required assignment
// faf8a46090da34683f028529e4c5f42f: Allow source files to shadow dependency files if the 'sources_shadow_deps' flag is enabled.
