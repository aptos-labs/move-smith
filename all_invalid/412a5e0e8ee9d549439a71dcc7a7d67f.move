//# publish
module 0xCAFE::WildcardAccessTest {
    // A struct with various fields to test access permissions
    struct DataStructure has key, store {
        field1: u64,
        field2: bool,
        field3: vector<u8>,
    }

    // Helper function to create a DataStructure instance
    public fun create_data_struct(): DataStructure {
        DataStructure {
            field1: 42,
            field2: true,
            field3: b"hello",
        }
    }

    // Function to get all fields using wildcard-like access via functions
    public fun get_field1(ds: &DataStructure): u64 {
        ds.field1
    }

    public fun get_field2(ds: &DataStructure): bool {
        ds.field2
    }

    public fun get_field3(ds: &DataStructure): vector<u8> {
        ds.field3.clone()
    }

    // Function to update fields, demonstrating access
    public fun set_field1(ds: &mut DataStructure, value: u64) {
        ds.field1 = value;
    }

    public fun set_field2(ds: &mut DataStructure, value: bool) {
        ds.field2 = value;
    }

    public fun set_field3(ds: &mut DataStructure, value: vector<u8>) {
        ds.field3 = value;
    }
}

//# run 0xCAFE::WildcardAccessTest::create_data_struct --signers 0xCAFE
//# run 0xCAFE::WildcardAccessTest::get_field1 --signers 0xCAFE --args 42u64
//# run 0xCAFE::WildcardAccessTest::get_field2 --signers 0xCAFE
//# run 0xCAFE::WildcardAccessTest::get_field3 --signers 0xCAFE
//# run 0xCAFE::WildcardAccessTest::set_field1 --signers 0xCAFE --args 100u64
//# run 0xCAFE::WildcardAccessTest::set_field2 --signers 0xCAFE --args false
//# run 0xCAFE::WildcardAccessTest::set_field3 --signers 0xCAFE --args b"world"

// Additional script to test module and address reference conversions and quantifiers with 'where' clauses
//# publish
module 0xCAFE::QuantifierWhereTest {
    // A simple list of numbers
    struct NumberList has key {
        nums: vector<u64>,
    }

    // Function to create a list
    public fun create_list(): NumberList {
        NumberList {
            nums: vec![10, 20, 30, 40, 50],
        }
    }

    // Function to check if all numbers are greater than a threshold
    public fun all_greater_than(list: &NumberList, threshold: u64): bool {
        // Using for_each-like pattern with 'where'
        exists (0, list.nums, |i: u64| {
            // bound check
            if (i as u64) < vector::length(&list.nums) {
                let val = *vector::Borrow<&u64>(&list.nums, i);
                val > threshold
            } else {
                false
            }
        }) where {
            // Since Move does not support lambdas with 'where' directly, simulate with a loop
            // but for the test, use a conceptual 'where'-like clause.
        }
        // Alternatively, simulate with manual check
        let all_ok = true;
        let len = vector::length(&list.nums);
        let i = 0;
        while (i < len) {
            if (*vector::borrow(&list.nums, i)) <= threshold {
                all_ok = false;
                break;
            }
            i = i + 1;
        }
        all_ok
    }
}

//# run 0xCAFE::QuantifierWhereTest::create_list --signers 0xCAFE
//# run 0xCAFE::QuantifierWhereTest::all_greater_than --signers 0xCAFE --args 5u64

// Featurres:
// b6bd62c2f45860d031831d2366ba177e: Allow the use of wildcards in name accesses when permitted by context (e.g., Module::*).
// bfd59e2009020d70ca7e04b65ab54ed0: Convert module or address references like 'Module.' or 'Address.' to 'Module::' or 'Address::' syntax.
// d945dc417d77917518473d5006c670b6: Use 'where' clauses within quantifiers to specify conditions.
