//# publish
module 0xCAFE::CopyAndIdTest {
    use std::signer;
    use std::address;

    struct Data has copy, drop, store, key {
        value: u8,
    }

    public fun create_data(v: u8): Data {
        Data { value: v }
    }

    public fun copy_value(d: Data): u8 {
        let copy_d = copy d;
        copy_d.value
    }

    public fun multiple_copies(v: u8): u8 {
        let d1 = Data { value: v };
        let d2 = copy d1;
        let d3 = copy d2;
        d3.value
    }

    public fun omit_self_qualifier(s: signer, v: u8): u8 {
        let d = Data { value: v };
        store_data(&s, d);
        borrow_data(&s).value
    }

    fun store_data(s: &signer, d: Data) {
        move_to<Data>(s, d);
    }

    fun borrow_data(s: &signer): &Data {
        borrow_global<Data>(signer::address_of(s))
    }

    public fun runner(): u8 {
        let d = create_data(10);
        let _ = copy_value(d);
        let _ = multiple_copies(20);
        let addr = @0xBA5E;
        let signer_ref = signer::address_to_signer(addr);
        omit_self_qualifier(signer_ref, 30)
    }
}

//# run 0xCAFE::CopyAndIdTest::runner