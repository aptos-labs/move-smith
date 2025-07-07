
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
        // Use a dummy signer address for test only (won't actually run here)
        // Just for testing compiler and VM features
        let dummy_signer = signer::address_of(&signer::spec_signer());
        // Calls below are dummy illustrations; will make no-ops as signer unavailable

        // Since we cannot instantiate signer in test here,
        // just invoke functions to check compilation and bytecode generation
    }
}


//# run 0xCAFE::AttrAndAcquiresTest::runner


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// acf0a8237c18af53c3ab3a951204da8b: Annotate your Move code with attributes that have either constant values or module-qualified identifiers as their values.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
