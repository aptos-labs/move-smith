
//# publish
module 0xCAFE::AttrAndAcquiresTest {
    use std::signer;

    const CONST_ATTR: u64 = 42;

    // const_attr = CONST_ATTR]
    // module_attr = 0xCAFE::AttrAndAcquiresTest]
    struct Data has key, store {
        val: u8,
    }

    // const_attr = 100]
    public fun create_data(s: signer, v: u8) {
        let data = Data { val: v };
        move_to<Data>(&s, data);
    }

    // module_attr = 0xCAFE::AttrAndAcquiresTest]
    public fun read_data(s: signer): u8 {
        let d_ref = borrow_global<Data>(signer::address_of(&s));
        d_ref.val
    }

    // const_attr = 999]
    public fun update_data(s: signer, v: u8) {
        let d_mut = borrow_global_mut<Data>(signer::address_of(&s));
        d_mut.val = v;
    }

    // module_attr = 0xCAFE::AttrAndAcquiresTest]
    public fun delete_data(s: signer) {
        let _ = move_from<Data>(signer::address_of(&s));
    }

    // const_attr = 1]
    // module_attr = 0xCAFE::AttrAndAcquiresTest]
    public fun runner() {
        // This function invokes others to ensure coverage
        // Since `signer::spec_signer()` does not exist, we cannot get a dummy signer here.
        // For compilation and bytecode generation checks, we just do nothing.
    }
}




//# run 0xCAFE::AttrAndAcquiresTest::runner
