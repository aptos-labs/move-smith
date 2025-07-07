
//# publish
module 0xCAFE::TestControlFlowAndGenerics {
    use std::vector;

    // Struct with type parameter
    struct Container<T> has copy, drop, store {
        items: vector<T>,
    }

    public fun create_container<T>(items: vector<T>): Container<T> {
        Container { items }
    }

    // Function to compare vectors
    public fun vectors_equal<T: copy + drop + store + eq>(v1: &vector<T>, v2: &vector<T>): bool {
        vector::length(v1) == vector::length(v2) && {
            let i = 0;
            let len = vector::length(v1);
            let result = true;
            while (i < len) {
                if (!(*vector::borrow(v1, i) == *vector::borrow(v2, i))) {
                    result = false;
                };
                i = i + 1;
            };
            result
        }
    }

    // Function to test control flow inside vector copying
    public fun control_flow_copy_test(): vector<u8> {
        let v = vector::empty<u8>();
        let i = 0;
        // Insert some elements before control flow alterations
        while (i < 5) {
            vector::push_back(&mut v, i);
            i = i + 1;
        };

        // Using break inside loop
        i = 0;
        while (i < 10) {
            if (i == 3) {
                break;
            };
            vector::push_back(&mut v, i + 10);
            i = i + 1;
        };

        // Using continue
        i = 0;
        while (i < 5) {
            if (i == 2) {
                i = i + 1;
                continue;
            };
            vector::push_back(&mut v, i + 20);
            i = i + 1;
        };

        // Multiple breaks
        i = 0;
        while (i < 10) {
            if (i == 7) {
                break;
            } else if (i == 4) {
                break;
            } else {
                vector::push_back(&mut v, i + 30);
            };
            i = i + 1;
        };

        // Asserts to verify vector correctness after control flows
        assert!(vector::length(&v) >= 5, 999);
        v
    }

    // Function to declare and compare constant vectors
    public fun const_vectors_test(): bool {
        // Declare empty vector
        let empty_vec: vector<u8> = vector::empty<u8>();

        // Declare a vector with elements
        let const_vec: vector<u8> = b"Hello";

        // Declare composite vector
        let composite_vec: vector<vector<u8>> = vector::empty();

        vector::push_back(&mut composite_vec, b"foo");
        vector::push_back(&mut composite_vec, b"bar");

        // Compare for equality
        let is_equal = vectors_equal(&const_vec, &vector::from_bytes(b"Hello"));
        // Return comparison result
        is_equal
    }

    // Function to initialize vectors with const and check references
    public fun refs_and_consts(): bool {
        let const_empty: vector<u8> = vector::empty();
        let const_bytes: vector<u8> = b"CONST";
        let ref_const_bytes = &const_bytes;

        // Compare reference to original
        vector::length(ref_const_bytes) == 5
    }

    // Runner to execute all tests
    public fun run_all_tests() {
        let _ = control_flow_copy_test();
        let _ = const_vectors_test();
        let _ = refs_and_consts();
        // Create a generic container with a vector
        let vec = vector::empty<u64>();
        vector::push_back(&mut vec, 42);
        let container: Container<u64> = create_container(vec);
        // Copy container vector
        let _ = break; // intentional syntax placeholder
        // No actual break here, just to ensure no invariant violations
    }
}


//# run 0xCAFE::TestControlFlowAndGenerics::run_all_tests --signers 0xBEEF


// Featurres:
// 85312436646f64b720f99bf2fbf145a3: Verify that copying vectors after various control flow operations (break, assert, continue, multiple breaks) does not cause invariant violations or errors.
// ed834f585afc143c8a555e6c1489a6cd: Declare type parameters for generic structs or functions in Move.
// aae22484d9570b12e491b8e0d69bee6d: Test that const-initialized vectors, including empty and composite vectors, can be created, compared for equality, and referenced in Move code.
