
//# publish
module 0xCAFE::AttributeAndAcquiresTest {
    use std::signer;
    use std::string;

    // deprecated = 0] // constant value attribute
    // metadata = 0xCAFE::AttributeAndAcquiresTest::meta_id] // module-qualified identifier attribute
    const META_VALUE: u8 = 42;

    const meta_id: u8 = 1;

    struct Data has store, key {
        value: u64,
    }

    // version = 1]
    public fun create_data(s: signer, val: u64) {
        let addr = signer::address_of(&s);
        let data = Data { value: val };
        move_to<Data>(&s, data);
    }

    // version = 1]
    public fun read_data(s: signer): u64 {
        let addr = signer::address_of(&s);
        let data_ref = borrow_global<Data>(addr);
        data_ref.value
    }

    // version = 1]
    public fun update_data(s: signer, val: u64) {
        let addr = signer::address_of(&s);
        let data_ref_mut = borrow_global_mut<Data>(addr);
        data_ref_mut.value = val;
    }

    // version = 1]
    public fun delete_data(s: signer) {
        let addr = signer::address_of(&s);
        let data = move_from<Data>(addr);
        let Data { value: _ } = data;
    }

    // version = 1]
    public fun no_data_function(): u64 {
        100
    }

    // version = 1]
    public fun infer_acquires(s: signer, val: u64) {
        // This function relies on implicit acquires inference, no explicit acquires needed
        create_data(s, val);
        update_data(s, val + 1);
        let _val = read_data(s);
        delete_data(s);
    }
}


//# run 0xCAFE::AttributeAndAcquiresTest::create_data --signers 0xB000 --args 123u64


//# run 0xCAFE::AttributeAndAcquiresTest::read_data --signers 0xB000


//# run 0xCAFE::AttributeAndAcquiresTest::update_data --signers 0xB000 --args 456u64


//# run 0xCAFE::AttributeAndAcquiresTest::read_data --signers 0xB000


//# run 0xCAFE::AttributeAndAcquiresTest::infer_acquires --signers 0xB001 --args 789u64


//# run 0xCAFE::AttributeAndAcquiresTest::no_data_function


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// acf0a8237c18af53c3ab3a951204da8b: Annotate your Move code with attributes that have either constant values or module-qualified identifiers as their values.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
