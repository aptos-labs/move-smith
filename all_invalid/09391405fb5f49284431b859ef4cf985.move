//# publish
module 0xCAFE::LambdaAndInitTest {
    use std::vector;
    use std::debug;

    struct Storage has store {
        keys: vector<vector<u8>>,
        values: vector<u64>,
    }

    // Initialize Storage struct by mapping keys to their lengths+2,
    // and adding 3 to each value in values.
    public fun init(keys: vector<vector<u8>>, values: vector<u64>): Storage {
        let mapped_keys = map_keys_lengths_plus_two(&keys);
        let updated_values = map_values_add_three(&values);
        Storage {
            keys: mapped_keys,
            values: updated_values,
        }
    }

    fun map_keys_lengths_plus_two(keys: &vector<vector<u8>>): vector<vector<u8>> {
        let mut result = vector::empty<vector<u8>>();
        let len_keys = vector::length(keys);
        let mut i = 0;
        while (i < len_keys) {
            let key_ref = vector::borrow(keys, i);
            let key_len = vector::length(key_ref);
            let new_len = key_len + 2;
            // Represent length+2 as a vector<u8> with one element (for simplicity)
            let new_key = vector::singleton(new_len as u8);
            vector::push_back(&mut result, new_key);
            i = i + 1;
        };
        result
    }

    fun map_values_add_three(values: &vector<u64>): vector<u64> {
        let mut result = vector::empty<u64>();
        let len_values = vector::length(values);
        let mut i = 0;
        while (i < len_values) {
            let v_ref = vector::borrow(values, i);
            let new_val = *v_ref + 3;
            vector::push_back(&mut result, new_val);
            i = i + 1;
        };
        result
    }

    public fun test_lambda_capturing(): u64 {
        let captured = 10u64;
        let lam: |u64|u64 has copy+drop = |x: u64| {
            captured + x
        };
        lam(5u64)
    }

    public fun test_lambda_mut_and_print(): u64 {
        let mut captured = 100u64;
        let lam: |u64|u64 has copy+drop = |delta: u64| {
            // Just add delta to captured and return sum (cannot mutate captured, so do a local sum)
            let sum = captured + delta;
            sum
        };
        let result = lam(23u64);

        debug::print(&result);
        result
    }

    public fun runner() {
        let keys = vector[
            b"abc",
            b"xy"
        ];
        let values = vector[7u64, 11u64];
        let storage = init(keys, values);

        debug::print(&storage.keys);
        debug::print(&storage.values);

        let res1 = test_lambda_capturing();
        debug::print(&res1);

        let res2 = test_lambda_mut_and_print();
        debug::print(&res2);
    }
}

//# run 0xCAFE::LambdaAndInitTest::runner

// Featurres:
// 627844f84ecfc748b79956e89aeb9bf1: Test that calling the init function correctly maps the KEYS to their lengths plus two and adds three to each value in VALUES without errors.
// 14b8844f8e1d8d6ab35f01cacb9f4778: Define and use lambda functions (anonymous functions), including capturing variables.
// 0f9a1df90a08795314bcd60478c91cc0: Use the `print` function to display the debug representation of any type that implements `AstDebug`.
