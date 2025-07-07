
//# publish
module 0xCAFE::ReferenceAndHexTest {
    use std::signer;
    use std::vector;
    use std::move_to;

    struct Data has copy, drop, store {
        value: u8,
        info: vector<u8>,
    }

    public fun create_data(s: signer, v: u8) {
        let info_hex: vector<u8> = x"CAFEBABE";
        let data = Data { value: v, info: info_hex };
        move_to<Data>(&s, data);
    }

    public fun borrow_data_ref(s: &signer): (u8, vector<u8>) {
        let addr = signer::address_of(s);
        let data_ref: &Data = borrow_global<Data>(addr);
        // Wrap the tuple in parentheses and use the 'copy' keyword correctly
        (data_ref.value, vector::copy(&data_ref.info))
    }

    public fun update_data_value(s: &signer, new_value: u8) {
        let addr = signer::address_of(s);
        let data_ref_mut: &mut Data = borrow_global_mut<Data>(addr);
        data_ref_mut.value = new_value;
    }

    public fun runner() {
        // Do nothing, just a runner function without args
    }
}



//# run 0xCAFE::ReferenceAndHexTest::create_data --signers 0xBEEF --args 42u8



//# run 0xCAFE::ReferenceAndHexTest::borrow_data_ref --signers 0xBEEF



//# run 0xCAFE::ReferenceAndHexTest::update_data_value --signers 0xBEEF --args 84u8



//# run 0xCAFE::ReferenceAndHexTest::borrow_data_ref --signers 0xBEEF



//# run 0xCAFE::ReferenceAndHexTest::runner
