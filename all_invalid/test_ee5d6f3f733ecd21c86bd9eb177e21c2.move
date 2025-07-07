//# publish
module 0xabcde::variable_reassignment {
    fun test_reassign_and_compare(initial_value: u64): bool {
        let original = initial_value;
        let copy_variable = original;

        // Reassign original to a new value
        let original = original + 10;

        // The copy should remain unchanged
        let comparison = copy_variable == original;

        comparison
    }

    public fun main() {
        assert!(test_reassign_and_compare(42) == true, 0);
        assert!(test_reassign_and_compare(0) == true, 0);
        assert!(test_reassign_and_compare(1000) == true, 0);
    }
}

//# run 0xabcde::variable_reassignment::main