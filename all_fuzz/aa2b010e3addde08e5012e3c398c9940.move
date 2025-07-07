
//# publish
module 0xCAFE::ReferenceAndHexTest {
    use std::signer;

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
        (data_ref.value, copy data_ref.info)
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


// Featurres:
// b209c36a585632f90e3d0971998eb855: Use reference types to borrow data immutably without taking ownership.
// aa5d07c7f63825c1fedcba9b5f82c282: Write hexadecimal byte string literals using x"..." syntax in your Move code
// 0a38877e9df2d5e826a5ae54b1bf6abf: Convert scripts into modules when the experiment for attaching compiled modules is enabled.
