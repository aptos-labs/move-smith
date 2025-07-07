//# publish
module 0xCAFE::ConstResourceTest {
    use std::signer;

    const CONST_U8: u8 = 42u8;
    const CONST_U64: u64 = 0xCAFEBABE;
    const CONST_ADDR: address = @0xCAFE;

    struct Resource has key, store {
        data: u8,
    }

    public fun publish_resource(s: signer) {
        let r = Resource { data: CONST_U8 };
        move_to<Resource>(&s, r);
    }

    public fun read_resource(s: signer): u8 {
        let r_ref = borrow_global<Resource>(signer::address_of(&s));
        r_ref.data
    }

    /// Intentionally use an error code with module address to test error_location attribute
    #[error_location = "0xCAFE::ConstResourceTest"]
    public fun abort_if_wrong_data(s: signer) {
        let r_ref = borrow_global<Resource>(signer::address_of(&s));
        assert!(r_ref.data == CONST_U8, 0xDEAD);
    }

    public fun runner(s: signer) {
        publish_resource(s);
        let _ = read_resource(s);
        abort_if_wrong_data(s);
    }
}

//# run 0xCAFE::ConstResourceTest::runner --signers 0xBABE

// Featurres:
// 33ddd0111d3c9d597d4b3aef770ce646: Declare constants at the module level.
// bc2a8ea14950cfdfe2f7b048802f62e7: Test storing and retrieving a persistent custom resource for a specific signer account.
// bb3302e4d0fbd2c86757952a662b30a5: Provide module identifiers in 'error_location' testing attributes to aid error reporting in test execution
