//# publish
module 0xabcde::test_module {

    //# publish
    /// This module tests that modifications to a local variable via move semantics do not affect moves elsewhere,
    /// ensuring proper move semantics enforcement.
    fun local_modify_and_return(b: bool, p: u64): u64 {
        let a = p;
        if (b) {
            a = 42; // Modify local variable without affecting move semantics elsewhere.
        };
        // Return a copy, ensuring no moves are unintentionally duplicated.
        a
    }

    public fun test_local_move() {
        // The first should return the modified value when b is true.
        assert!(local_modify_and_return(true, 10) == 42, 0);
        // The second should return the original p when b is false.
        assert!(local_modify_and_return(false, 29) == 29, 1);
    }

    //# run 0xabcde::test_module::test_local_move

    //# publish
    /// This module tests that mutably borrowing a parameter does not alter the original during an assertion,
    /// emphasizing move semantics preservation.
    fun borrow_and_return_original(p: u64): u64 {
        let a = p;
        let r = &mut p;
        *r = 100; // mutate through mutable reference
        a // return original value, should remain unaffected
    }

    public fun test_borrow_and_return() {
        assert!(borrow_and_return_original(55) == 55, 0);
        assert!(borrow_and_return_original(0) == 0, 1);
    }

    //# run 0xabcde::test_module::test_borrow_and_return

    //# publish
    /// This module verifies that passing mutable references to functions and modifying them
    /// correctly impacts the original variable, with assertions confirming the expected final state.
    fun increment_ref(r: &mut u64) {
        *r += 3;
    }

    fun double_ref(r: &mut u64) {
        *r *= 2;
    }

    public fun test_mutable_refs() {
        let mut x = 4;
        increment_ref(&mut x);
        // x should now be 7
        assert!(x == 7, 0);
        double_ref(&mut x);
        // x should now be 14
        assert!(x == 14, 1);
    }

    //# run --verbose -- 0xabcde::test_module::test_mutable_refs
}