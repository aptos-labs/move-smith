
//# publish
module 0xCAFE::VectorUtils {
    use std::vector;
    
    // Copy a vector of u64 and return the sorted copy
    public fun copy_and_sort(v: vector<u64>): vector<u64> {
        let copy_v = vector::empty<u64>();
        let len = vector::length(&v);
        let i = 0u64;
        while (i < len) {
            vector::push_back(&mut copy_v, *vector::borrow(&v, i as usize));
            i = i + 1;
        };
        vector::sort(&mut copy_v);
        copy_v
    }

    // Check if two u64 vectors are equal, return true if equal
    public fun vectors_equal(v1: &vector<u64>, v2: &vector<u64>): bool {
        if (vector::length(v1) != vector::length(v2)) {
            false
        } else {
            let len = vector::length(v1);
            let i = 0u64;
            let eq = true;
            while (i < len && eq) {
                if (*vector::borrow(v1, i as usize) != *vector::borrow(v2, i as usize)) {
                    eq = false;
                };
                i = i + 1;
            };
            eq
        }
    }

    // A runner function to test vector copying, sorting, and equality
    public fun run_tests() {
        let v1 = vector[10u64, 3u64, 7u64, 1u64, 5u64];
        let sorted_v1 = Self::copy_and_sort(v1);
        let expected_sorted = vector[1u64, 3u64, 5u64, 7u64, 10u64];
        assert!(Self::vectors_equal(&sorted_v1, &expected_sorted), 123);
        assert!(Self::vectors_equal(&sorted_v1, &sorted_v1), 124);
        let v2 = vector[1u64, 2u64, 3u64];
        assert!(!Self::vectors_equal(&sorted_v1, &v2), 125);
    }

    spec module {
      fun sorted(v: vector<u64>): vector<u64> {
        vector::sort(&mut v);
        v
      }
      // Remove the invalid spec fun declaration or replace with an axiom or assume if needed.
    }
}


//# run 0xCAFE::VectorUtils::run_tests
