
//# publish
module 0xCAFE::AttributeAndAcquireTest {
    use std::signer;

    // version = 2]
    // author = 0xCAFE]
    struct Dummy has copy, drop, store {}

    // constant_attribute = 42]
    // module_attribute = 0xCAFE::AttributeAndAcquireTest]
    public fun annotated_function_one(s: signer) {
        // Function that moves Dummy resource to signer; auto acquire by compiler V2_2+
        let d = Dummy {};
        move_to<Dummy>(&s, d);
    }

    // version = 2]
    // author = 0xBEEF]
    public fun annotated_function_two(s: signer) {
        let d_ref = borrow_global<Dummy>(signer::address_of(&s));
        let _dummy_copy = copy d_ref;
    }

    // version = 2]
    // author = 0xBABE]
    public fun annotated_function_three(s: signer) {
        let d = move_from<Dummy>(signer::address_of(&s));
        drop(d);
    }

    // constant_attribute = 123]
    // module_attribute = 0xCAFE::AttributeAndAcquireTest]
    public fun runner(s: signer) {
        annotated_function_one(s);
        annotated_function_two(s);
        annotated_function_three(s);
    }
}



//# run 0xCAFE::AttributeAndAcquireTest::runner --signers 0xBEEF
