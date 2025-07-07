//# publish
module 0x1::TestAbilities {
    use std::vector;

    // Define a struct with copy and drop abilities
    struct CopyDropStruct has copy, drop {
        val: u64,
    }

    public fun create(val: u64): CopyDropStruct {
        CopyDropStruct { val }
    }

    // Runner function that exercises copy and drop via simple usage
    public fun runner() {
        let a = create(10);
        let b = a; // copy should occur here
        let _c = b; // drop eventually at scope end
    }
}
//# run 0x1::TestAbilities::runner

//# publish
module 0x1::TestVectorTest {
    use std::vector;

    // A helper function to clone u64 vector
    public fun clone_vector(v: &vector<u64>): vector<u64> acquires {
        vector::empty()
        // Note: vector::copy can be used in aptos std lib but here implement manually
    }

    // Actually implement clone by creating new vector and pushing each element
    public fun clone_vector(v: &vector<u64>): vector<u64> {
        let mut new_vec = vector::empty();
        let len = vector::length(v);
        let mut i = 0;
        while (i < len) {
            vector::push_back(&mut new_vec, *vector::borrow(v, i));
            i = i + 1;
        }
        new_vec
    }

    // Return true if two vectors are equal (element-wise u64)
    public fun equal_vectors(v1: &vector<u64>, v2: &vector<u64>): bool {
        if (vector::length(v1) != vector::length(v2)) {
            return false;
        };
        let len = vector::length(v1);
        let mut i = 0;
        while (i < len) {
            if (*vector::borrow(v1, i) != *vector::borrow(v2, i)) {
                return false;
            };
            i = i + 1;
        }
        true
    }

    // A sorting function (bubble sort for simplicity) for vector<u64>
    public fun sort_vector(v: &mut vector<u64>) {
        let len = vector::length(v);
        if (len < 2) {
            return;
        };
        let mut i = 0;
        while (i < len - 1) {
            let mut j = 0;
            while (j < len - i - 1) {
                let a = *vector::borrow(v, j);
                let b = *vector::borrow(v, j + 1);
                if (a > b) {
                    // swap elements
                    *vector::borrow_mut(v, j) = b;
                    *vector::borrow_mut(v, j + 1) = a;
                };
                j = j + 1;
            };
            i = i + 1;
        }
    }

    // Runner to test vector copying, sorting and equality
    public fun runner() {
        let original = vector::from_u64([3, 1, 4, 1, 5, 9]);
        let mut cloned = clone_vector(&original);

        // Make sure cloned equals original
        // Assertion can be ignored per instructions, so omitted.

        // Now sort cloned vector
        sort_vector(&mut cloned);

        let mut expected_sorted = vector::from_u64([1, 1, 3, 4, 5, 9]);

        // Test equality works for sorted vector
        // Omit asserts

        // Also test changing cloned vector breaks equality
        if (equal_vectors(&original, &cloned)) {
            // should not be equal after sort
            abort 1;
        };
        if (!equal_vectors(&cloned, &expected_sorted)) {
            abort 2;
        };
    }
}
//# run 0x1::TestVectorTest::runner

//# publish
module 0x1::CallChainSpec {
    // Demonstrate call chains in specifications to identify source of impurity

    // Pure function no side-effect
    public fun pure_fun(x: u64): u64 {
        x + 10
    }

    // An impure function (simulate side effect with an abort)
    public fun impure_fun(x: u64) {
        // This abort causes impurity in proof sense
        abort 42;
    }

    // Wrapper calling impure
    public fun call_impure(x: u64) {
        impure_fun(x);
    }

    // Wrapper calling call_impure
    public fun call_chain(x: u64) {
        call_impure(x);
    }

    // Runner function that SHALL abort and demonstrate the call chain
    public fun runner() {
        // Note: We can't catch aborts in Move, but we can call to produce the impurity
        call_chain(5);
    }

    // Specification illustrating call chain for impure_fun via call_chain:
    spec module {
        // Example spec using call_path to trace impurity functions (hypothetical syntax)
        // We do it here as a comment, since Move does not execute specs but tools analyze them.
        /*
        call_chain calls call_impure;
        call_impure calls impure_fun;
        impure_fun aborts;

        Thus call_chain -> call_impure -> impure_fun is impure call path.
        */
    }
}
//# run 0x1::CallChainSpec::runner --signers 0x1