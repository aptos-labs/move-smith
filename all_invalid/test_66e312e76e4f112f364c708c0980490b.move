//# publish
module 0x1::test_immutable_vars {
    fun verify_immutable() {
        let a = 10;
        // The following line should cause an error if uncommented, as 'a' is immutable
        // a = 20;

        let b = 5;
        // The following line should cause an error if uncommented, as 'b' is immutable
        // b = b + 1;

        // Alternatively, to demonstrate no mutation, just use the variables
        let sum = a + b;
        assert!(sum == 15, 0);
    }

    public fun main() {
        verify_immutable();
    }
}

//# run 0x1::test_immutable_vars::main

//# publish
module 0x2::init_vectors {
    use std::vector;

    public entry fun initiate_vectors() {
        let empty_keys: vector<vector<u8>> = vector::empty<vector<u8>>();
        let empty_values: vector<u64> = vector::empty<u64>();

        let new_keys: vector<vector<u8>> = vector::map<vector<u8>, vector<u8>>(empty_keys, |key| { key });
        let new_values: vector<u64> = vector::map<u64, u64>(empty_values, |v| { v + 10 });

        // For testing purposes, just assert new vectors are empty
        assert!(vector::length(&new_keys) == 0, 1);
        assert!(vector::length(&new_values) == 0, 2);
    }
}

//# run 0x2::init_vectors::initiate_vectors

//# publish
module 0x3::logic_operations {
    fun evaluate_logic(): bool {
        // Testing various logical combinations
        let t_and_f = true && false;
        let t_or_f = true || false;
        let not_true = !true;
        let not_false = !false;

        // Complex expression: (true && false) || (!true && (false || true))
        let complex_expr = (true && false) || ((!true) && (false || true));
        // which simplifies to false || (false && true) -> false || false -> false

        assert!(t_and_f == false, 3);
        assert!(t_or_f == true, 4);
        assert!(!not_true, 5);
        assert!(not_false, 6);
        assert!(!complex_expr, 7);

        // Return a boolean indicating overall success
        complex_expr
    }

    public fun main() {
        assert!(evaluate_logic(), 8);
    }
}

//# run 0x3::logic_operations::main