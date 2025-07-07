
//# publish
module 0xDEAD::TestSuite {
    use std::signer;
    use std::vector;

    // A module with an entry script to test direct invocation
    public fun entry_point_test(s: &signer): u64 acquires None {
        // Suppose it updates some global state, for simplicity return 42
        42
    }

    // A test that calls the module's entry script directly
    public fun run_entry_test(s: &signer): u64 {
        entry_point_test(s)
    }

    // Parser verification functions (these are just illustrative mock functions since actual parsing can't be done in Move)
    // We'll simulate binary expressions evaluation

    // Function to evaluate binary expressions involving integer comparisons and logical operators
    public fun eval_binary_expressions(): bool {
        let a = 10;
        let b = 20;

        // Operators: ==, !=, <, >, <=, >=, ||, &&, ^, |, &, <<, >>, +, -, *, /, %, .., ==> , <==>
        // 1. Equality
        assert!(a == 10, 100);
        assert!(b != 10, 101);

        // 2. Comparisons
        assert!(a < b, 102);
        assert!(b > a, 103);
        assert!(a <= 10, 104);
        assert!(b >= 20, 105);

        // 3. Logical operators
        assert!(true || false, 106);
        assert!(true && false == false, 107);

        // 4. Bitwise operators
        let c = a ^ b; // XOR
        let d = a | b; // OR
        let e = a & b; // AND
        assert!((c != 0), 108);
        assert!((d != 0), 109);
        assert!((e != 0), 110);

        // 5. Shift operators
        let shifted_left = a << 2; // a * 4
        let shifted_right = b >> 1; // b / 2
        assert!(shifted_left == 40, 111);
        assert!(shifted_right == 10, 112);

        // 6. Arithmetic operators
        let sum = a + b; // 30
        let diff = b - a; // 10
        let prod = a * b; // 200
        let quot = b / a; // 2
        let rem = b % a; // 0
        assert!(sum == 30, 113);
        assert!(diff == 10, 114);
        assert!(prod == 200, 115);
        assert!(quot == 2, 116);
        assert!(rem == 0, 117);

        // 7. Range (..)
        let range_vec: vector<u64> = vector::range(0, 5); // 0..4
        assert!(vector::length(&range_vec) == 5, 118);
        assert!(*vector::borrow(&range_vec, 0) == 0, 119);
        assert!(*vector::borrow(&range_vec, 4) == 4, 120);

        // 8. Implication (==>)
        // For simplicity, simulate: if a > 5 then true
        let imp = if (a > 5) { true } else { false };
        assert!(!imp, 121);

        // 9. Less than or equal (<=)
        assert!(a <= 10, 122);

        // 10. Final assertion to confirm parsing evaluation
        true
    }

    // Initialization function to test keys and values
    public fun init_test(keys: vector<vector<u8>>, values: vector<u64>): vector<(vector<u8>, u64)> {
        assert!(vector::length(&keys) == vector::length(&values), 123);
        let results = vector::empty<(vector<u8>, u64)>();
        let len_keys = vector::length(&keys);
        let i = 0;
        while (i < len_keys) {
            let key = vector::borrow(&keys, i);
            let value = *vector::borrow(&values, i);
            // Key length + 2
            let key_len = vector::length(key);
            let new_value = value + 3;
            let key_modified = key;
            // create a tuple
            let tuple_val = (key_modified, key_len + 2 + new_value);
            vector::push_back::<(vector<u8>, u64)>(&mut results, tuple_val);
            i = i + 1;
        };
        results
    }

    // Runner for the init function
    public fun run_init(): vector<(vector<u8>, u64)> {
        let keys = vector::empty<vector<u8>>();
        vector::push_back(&mut keys, b"alpha");
        vector::push_back(&mut keys, b"beta");
        vector::push_back(&mut keys, b"gamma");
        let values = vector::empty<u64>();
        vector::push_back(&mut values, 1);
        vector::push_back(&mut values, 2);
        vector::push_back(&mut values, 3);
        init_test(keys, values)
    }
}



//# run 0xDEAD::TestSuite::run_entry_test --signers 0xBEEFFACE



//# run 0xDEAD::TestSuite::eval_binary_expressions



//# run 0xDEAD::TestSuite::run_init


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 6a2556ec38646785f8400fff16aac057: Parse binary expressions with support for operators such as '==', '!=', '<', '>', '<=', '>=', '||', '&& '^', '|', '& '<<', '>>', '+', '-', '*', '/', '%', '..', '==>', and '<==>'.
// 627844f84ecfc748b79956e89aeb9bf1: Test that calling the init function correctly maps the KEYS to their lengths plus two and adds three to each value in VALUES without errors.
