//# publish
module 0xCAFE::VectorAndAddressTest {
    use std::vector;
    use std::signer;

    struct AddressHolder has store, key {
        addr_list: vector<address>,
        num_list: vector<u64>,
    }

    public fun create_vectors(): (vector<u8>, vector<address>, vector<bool>) {
        // Create vector of u8
        let v_u8 = vector[1u8, 2u8, 3u8, 4u8];

        // Create vector of addresses
        let v_addr = vector[@0x1, @0xCAFE, @0xBEEF];

        // Create vector of booleans
        let v_bool = vector[true, false, true];

        (v_u8, v_addr, v_bool)
    }

    public fun create_and_store_struct(s: signer) {
        // Use addresses with correct @<address> notation (no u64 suffix)
        let addresses = vector[@0x10, @0x20, @0x30];
        let numbers = vector[10u64, 20u64, 30u64];

        let holder = AddressHolder {
            addr_list: addresses,
            num_list: numbers,
        };
        move_to<AddressHolder>(&s, holder);
    }

    public fun check_address_and_numbers(s: signer): (u64, address) {
        let holder_ref = borrow_global<AddressHolder>(signer::address_of(&s));
        // Access element to exercise indexing and address usage
        let num = *vector::borrow(&holder_ref.num_list, 1);
        let addr = *vector::borrow(&holder_ref.addr_list, 2);
        (num, addr)
    }

    public fun run_filter_on_addresses(s: signer): vector<address> {
        let holder_ref = borrow_global<AddressHolder>(signer::address_of(&s));
        let addrs = &holder_ref.addr_list;

        let mut filtered = vector::empty<address>();
        let len = vector::length(addrs);
        let mut i = 0;

        loop {
            if (i >= len) { break; };
            let addr = *vector::borrow(addrs, i);
            // Filter out address 0x20 but keep others
            if (addr != @0x20) {
                vector::push_back(&mut filtered, addr);
            };
            i = i + 1;
        };
        filtered
    }

    public fun runner(s: signer) {
        let (_v1, _v2, _v3) = create_vectors();

        create_and_store_struct(s);

        let (_num, _addr) = check_address_and_numbers(s);

        let _filtered_addrs = run_filter_on_addresses(s);
    }
}

//# run 0xCAFE::VectorAndAddressTest::create_vectors

//# run 0xCAFE::VectorAndAddressTest::create_and_store_struct --signers 0xBEEF

//# run 0xCAFE::VectorAndAddressTest::check_address_and_numbers --signers 0xBEEF

//# run 0xCAFE::VectorAndAddressTest::run_filter_on_addresses --signers 0xBEEF

//# run 0xCAFE::VectorAndAddressTest::runner --signers 0xBEEF