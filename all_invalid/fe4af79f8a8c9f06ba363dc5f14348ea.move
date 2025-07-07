
//# publish
module 0xCAFE::SpecAndReferenceTest {
    use std::signer;

    struct Data has store {
        value: u64,
    }

    spec fun get_value_as_spec(data: &Data): u64 {
        data.value
    }

    public fun new_data(s: signer, val: u64) {
        let data = Data { value: val };
        move_to<Data>(&s, data);
    }

    public fun reassign_ref(s: signer) {
        let addr = signer::address_of(&s);
        let data_ref: &Data = borrow_global<Data>(addr);

        // Reassign reference variable to a new reference of same resource
        let data_ref = borrow_global<Data>(addr);

        let _val: u64 = data_ref.value;
    }

    // Remove 'spec' keyword here as it causes compilation error.
    // 'spec' functions cannot have return types specified in this position.
    spec fun spec_return_type(data: &Data): u64 {
        get_value_as_spec(data)
    }
}



//# run 0xCAFE::SpecAndReferenceTest::new_data --signers 0xBEEF --args 123u64



//# run 0xCAFE::SpecAndReferenceTest::reassign_ref --signers 0xBEEF
