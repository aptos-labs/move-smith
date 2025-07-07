
//# publish
module 0xCAFE::TargetEnvTest {
    use std::signer;
    use std::vector;

    struct TargetResource has key, store {
        val: u64,
    }

    public fun publish_resource(s: signer, val: u64) {
        let r = TargetResource { val };
        move_to<TargetResource>(&s, r);
    }

    public fun borrow_and_update_conditional(s: signer, should_update: bool, new_val: u64): u64 {
        let addr = signer::address_of(&s);
        if (should_update) {
            let res_ref_mut: &mut TargetResource = borrow_global_mut<TargetResource>(addr);
            res_ref_mut.val = new_val;
        } else {
            let res_ref: &TargetResource = borrow_global<TargetResource>(addr);
            // just read without update
            assert!(res_ref.val > 0, 99);
        };
        // return current val after possible update
        let res_ref_final: &TargetResource = borrow_global<TargetResource>(addr);
        res_ref_final.val
    }

    // Converts dotted address or module references to double colon syntax - demonstration function
    public fun convert_dotted_to_colon(dotted_ref: vector<u8>): vector<u8> {
        // This is a dummy function just to simulate usage of dotted to double colon conversion concept,
        // returns input as is, actual conversion during compilation/runtime is out of scope of Move
        dotted_ref
    }

    public fun runner() {
        // publish a resource for this module's address (0xCAFE)
        let s = signer::new_signer(0xCAFE);
        publish_resource(s, 42);
        // borrow without update
        let _ = borrow_and_update_conditional(s, false, 0);
        // borrow with update
        let _ = borrow_and_update_conditional(s, true, 100);
        // use convert function dummy call
        let _ = convert_dotted_to_colon(vector::from_bytes(b"0xCAFE.Module"));
    }
}



//# run 0xCAFE::TargetEnvTest::runner



//# run 0xCAFE::TargetEnvTest::borrow_and_update_conditional --signers 0xDEAD --args false 0u64



//# run 0xCAFE::TargetEnvTest::borrow_and_update_conditional --signers 0xDEAD --args true 2024u64
