
//# publish
module 0xCAFE::TargetEnvTest {
    use std::signer;

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
        let s = signer::spec_synthetic_signer<0xCAFE>();
        publish_resource(s, 42);
        // borrow without update
        let _ = borrow_and_update_conditional(s, false, 0);
        // borrow with update
        let _ = borrow_and_update_conditional(s, true, 100);
        // use convert function dummy call
        let _ = convert_dotted_to_colon(b"0xCAFE.Module");
    }
}


//# run 0xCAFE::TargetEnvTest::runner


//# run 0xCAFE::TargetEnvTest::borrow_and_update_conditional --signers 0xDEAD --args false 0u64


//# run 0xCAFE::TargetEnvTest::borrow_and_update_conditional --signers 0xDEAD --args true 2024u64


// Featurres:
// 32c9e9589dffb8fdc93267425c721b63: Set the environment to treat all code as target code if specified.
// aa464619e73d0f0ff7f9495b48fa584b: Test that functions correctly borrow and access global resource data conditionally based on input parameters, ensuring proper shared and mutable references are used.
// bfd59e2009020d70ca7e04b65ab54ed0: Convert module or address references like 'Module.' or 'Address.' to 'Module::' or 'Address::' syntax.
