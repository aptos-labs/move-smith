
//# publish
module 0xCAFE::VisibilityTest {
    use std::signer;

    // Resource with visibility restricted to an explicit address
    struct PrivateResource has key {
        value: u64,
    }

    // Public resource accessible only by address 0xBEEF
    struct BEEFOnlyResource has key {}

    // Public resource accessible by any address (wildcard *)
    struct WildcardResource has key {
        data: bool,
    }

    // Publish PrivateResource under caller's address
    public fun publish_private_resource(s: signer, v: u64) {
        let addr = signer::address_of(&s);
        move_to<PrivateResource>(&s, PrivateResource { value: v });
    }

    // Read value of PrivateResource at caller address
    public fun read_private_resource(s: signer): u64 {
        let addr = signer::address_of(&s);
        let r = borrow_global<PrivateResource>(addr);
        r.value
    }

    // Function only callable by 0xBEEF, publishes BEEFOnlyResource at 0xBEEF
    public fun publish_beef_resource(s: signer) {
        let caller = signer::address_of(&s);
        // Restrict visibility with address 0xBEEF on a function
        assert!(caller == @0xBEEF, 1);
        move_to<BEEFOnlyResource>(&s, BEEFOnlyResource {});
    }

    // Function to check if BEEFOnlyResource exists at 0xBEEF
    public fun check_beef_resource(): bool {
        exists<BEEFOnlyResource>(@0xBEEF)
    }

    // Publish WildcardResource at caller address with data=true
    public fun publish_wildcard_resource(s: signer) {
        move_to<WildcardResource>(&s, WildcardResource { data: true });
    }

    // Read WildcardResource.data at any address by parameter
    public fun read_wildcard_resource(addr: address): bool {
        let r = borrow_global<WildcardResource>(addr);
        r.data
    }

    // A function that calls read_private_resource internally, referring by name without prefix
    public fun caller_reads_private(s: signer): u64 {
        read_private_resource(s)
    }

    // A function that calls check_beef_resource, referring to it via alias with "Self::" prefix
    public fun alias_check_beef(): bool {
        Self::check_beef_resource()
    }
}


//# run 0xCAFE::VisibilityTest::publish_private_resource --signers 0xB001 --args 42u64


//# run 0xCAFE::VisibilityTest::read_private_resource --signers 0xB001


//# run 0xCAFE::VisibilityTest::caller_reads_private --signers 0xB001


//# run 0xCAFE::VisibilityTest::publish_beef_resource --signers 0xBEEF


//# run 0xCAFE::VisibilityTest::check_beef_resource


//# run 0xCAFE::VisibilityTest::alias_check_beef


//# run 0xCAFE::VisibilityTest::publish_wildcard_resource --signers 0xC0DE


//# run 0xCAFE::VisibilityTest::read_wildcard_resource --args 0xC0DE


// Featurres:
// df82f3d049ccfcecf80883bfa2494d9d: Specify a custom address for access specifiers in visibility restrictions.
// 4524c941e71dd068b5bd278c754d71f7: Refer to a member (resource or function) directly by name within the current module or via an alias.
// 9999df3dd137daa985289c06925f7542: Specify an address using a wildcard '*' for any address.
