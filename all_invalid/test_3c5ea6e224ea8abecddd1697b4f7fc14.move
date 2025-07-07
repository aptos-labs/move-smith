//# publish
module 0x1::vector_utils {
    use std::vector;

    /// Applies a mutable function to each element in the vector, mutating elements in place.
    public fun for_each_mut<T>(
        vec: &mut vector<T>,
        f: &mut (pow: &mut T) { bool }
    ) {
        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            let e = &mut vector::borrow_mut(vec, i);
            (*f)(e);
            i = i + 1;
        }
    }

    /// Alternative version: returns a new vector with the transformed elements.
    public fun map_mut<T: copy, R: copy>(
        vec: &vector<T>,
        f: &mut (pow: &mut T) { R }
    ): vector<R> {
        let result = vector::empty<R>();
        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            let e = *vector::borrow(vec, i);
            let mapped = (*f)(&mut e);
            vector::push_back(&mut result, mapped);
            i = i + 1;
        }
        result
    }
}

//# run 0x1::vector_utils::test_mutate_and_transform

//# publish
module 0x2::vector_tests {
    use 0x1::vector_utils;
    use std::vector;

    /// Test in-place mutation: increment each element by a fixed value
    public fun test_in_place_mutation() {
        let mut v = vector[10, 20, 30];
        let mut delta = 5;
        vector_utils::for_each_mut(&mut v, &mut (|e| { *e = *e + delta; delta = delta + 1 }));
        assert!((vector::borrow(&v, 0)) == 15, 0);
        assert!((vector::borrow(&v, 1)) == 22, 1);
        assert!((vector::borrow(&v, 2)) == 30, 2);
    }

    /// Test mapping to a new vector: double each element plus index
    public fun test_map_mut() {
        let v = vector[1, 2, 3, 4];
        let mut f = |e: &mut u64| -> u64 { *e * 2 + 1 };
        let new_v = vector_utils::map_mut(&v, &mut f);
        assert!((vector::borrow(&new_v, 0)) == 3, 0);
        assert!((vector::borrow(&new_v, 1)) == 5, 1);
        assert!((vector::borrow(&new_v, 2)) == 7, 2);
        assert!((vector::borrow(&new_v, 3)) == 9, 3);
    }

    /// Test with an empty vector
    public fun test_empty_vector() {
        let mut v: vector<u64> = vector::empty<u64>();
        let mut f = |e: &mut u64| -> u64 { *e + 1 };
        vector_utils::for_each_mut(&mut v, &mut f);
        assert!(vector::length(&v) == 0, 0);
    }
}

//# run 0x2::vector_tests::test_in_place_mutation
//# run 0x2::vector_tests::test_map_mut
//# run 0x2::vector_tests::test_empty_vector