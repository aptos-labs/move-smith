//# publish
module 0xABC::early_return {
    fun run_once() {
        // Function to run in the script
        return;
    }

    public fun test_early_return() {
        // Call the helper function that returns early
        run_once();
        // If execution reaches here, it means the early return in run_once worked as intended
        // This function can be extended with assertions if needed
    }
}

//# run 0xABC::early_return::test_early_return


//# publish
module 0xDEF::vector_mutation {
    use std::vector;

    fun mutate_elements(v: &mut vector<u64>) {
        let mut i = 0;
        let len = vector::length(v);
        while (i < len) {
            let e = vector::borrow_mut(v, i);
            *e = *e + 10;
            i = i + 1;
        }
    }

    public fun test_vector_mutation() {
        let mut v = vector[5, 15, 25];
        mutate_elements(&mut v);
        assert!(v == vector[15, 25, 35], 100);
    }

    // Function to run the test
    public fun run() {
        test_vector_mutation();
    }
}

//# run 0xDEF::vector_mutation::run


//# publish
module 0x123::reference_sum {
    struct S has drop {
        val: u64
    }

    fun sum_refs(s1: &S, s2: &S): u64 {
        s1.val + s2.val
    }

    fun compute_sum() -> u64 {
        let s1 = S { val: 10 };
        let s2 = S { val: 20 };
        let ref_s1 = &s1;      // immutable reference
        let ref_s2 = &s2;      // immutable reference
        let mut s3 = S { val: 5 };
        let ref_s3 = &mut s3;  // mutable reference

        // Sum using various references
        sum_refs(ref_s1, ref_s2) + sum_refs(ref_s3, ref_s3)
    }

    public fun run() {
        let total = compute_sum();
        // No assertions, but can be inspected if needed
    }
}

//# run 0x123::reference_sum::run