
//# publish
module 0xC0FF::TestModule {
    use std::vector;

    struct Data has store, key {
        value: u8,
        flag: bool,
    }

    public fun create_data_at_address(addr: address, value: u8, flag: bool) acquires Data {
        move_to<Data>(&signer::borrow_signer(&addr), Data {value, flag});
    }

    public fun get_data_value(addr: address): u8 acquires Data {
        let data_ref: &Data = borrow_global<Data>(addr);
        data_ref.value
    }

    public fun update_data(addr: address, new_value: u8, new_flag: bool) acquires Data {
        let data_mut_ref: &mut Data = borrow_global_mut<Data>(addr);
        data_mut_ref.value = new_value;
        data_mut_ref.flag = new_flag;
    }

    public fun remove_data(addr: address) {
        move_from<Data>(addr);
    }

    public fun test_address_access() {
        let addr1: address = 0xDEADBEEFCAFEBABE;
        let addr2: address = 0xBEEFBABECAFED00D;

        create_data_at_address(addr1, 10, true);
        create_data_at_address(addr2, 20, false);

        let val1 = get_data_value(addr1);
        let val2 = get_data_value(addr2);

        update_data(addr1, 15, false);
        let updated_val1 = get_data_value(addr1);

        remove_data(addr2);
        // After removal, attempting to borrow global would panic, so skipped
    }

    public fun complex_grouping_tests() {
        let a: u8 = 5;
        let b: u8 = 10;
        let c: u8 = (a + b) * (a - 1); // note: no negatives, so (a - 1) = 4
        let d: u8 = ((a + b) as u8 + 2) * 3;

        let vec1: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut (vec1), c);
        vector::push_back(&mut (vec1), d);

        if (vector::length(&vec1) == 2) {
            let _val0 = *vector::borrow(&vec1, 0);
            let _val1 = *vector::borrow(&vec1, 1);
        } else {
            // do nothing
        };

        let array_group: [bool; 3] = [true, false, true];

        let nested_grouping = {
            let inner_group = [1u8, 2u8];
            let outer_group = [0u8, 1u8, 2u8, 3u8];
            outer_group
        };

        let _tuple_group = (a, (b, c), d);

        // nested parentheses
        let _nested = (((a + b) * c), { let x = 42; x });
    }

    public fun use_variable_in_punctuation() {
        let a: bool = true;
        let b: bool = false;

        // group with parentheses and commas
        if ((a, b)) {
            // do nothing
        };

        let _array: [u8; 3] = [1, 2, 3];

        // nested grouping with braces
        let _group = {
            let x = { let y = 5; y };
            x + 1
        };
    }

    public fun test_use_of_dot_range() {
        let range = 1..=5;
        let sum: u64 = {
            let total: u64 = 0;
            for i in &range {
                total += *i as u64;
            }
            total
        };

        sum
    }
}


//# run 0xC0FF::TestModule::test_address_access


//# run 0xC0FF::TestModule::complex_grouping_tests


//# run 0xC0FF::TestModule::use_variable_in_punctuation


//# run 0xC0FF::TestModule::test_use_of_dot_range


// Featurres:
// a67c4716a34e1345526cde917f209144: Write hexadecimal or numerical account addresses as literals in Move code
// 39f7aae1912ff9e11c15a3c2ea0559c1: Use various punctuation and grouping characters such as (), [], {}, ,, ;, #, @, and . (dot/range).
// d35b588c67cd02c800b53cd7282965d0: Use '&mut' to define mutable references in types.
