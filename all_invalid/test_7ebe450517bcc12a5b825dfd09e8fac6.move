//# publish
module 0xabcde::interaction_tests {
    fun fetch_and_recompute(p: u64): u64 {
        // Store the initial value
        let initial = p;
        // Create a copy of initial
        let copy = initial;
        // Reassign the input parameter
        let updated = p + 10;
        // Return the original stored value before update
        initial
    }

    public fun test_fetch_and_recompute() {
        assert!(fetch_and_recompute(7) == 7, 101);
    }

    public fun complex_arithmetics(x: u64): u64 {
        // Nested struct-like value manipulation via local variables
        let a = x;
        let mut b = a;
        // Basic arithmetic adjustments
        b = b + 5;
        let c = b * 2;

        // Reassign b after previous modifications
        b = c - 3;

        // Manipulate in nested expressions
        let result = (a + b) * 3 + (b - a);
        result
    }

    public fun test_complex_arithmetics() {
        let val = complex_arithmetics(4);
        assert!(val == ((4 + (4 + 5) * 2 - 3) * 3 + ((4 + 5) * 2 - 4)), 102);
    }

    public fun variable_reassignment_stability(p: u64): bool {
        // Copy variable and reassign the original
        let original = p;
        let mut copy = original;
        // Reassign original to a new value
        let _ = p + 20;
        // The copy should remain equal to the initial original
        copy == original
    }

    public fun test_variable_reassignment_stability() {
        assert!(variable_reassignment_stability(50) == true, 103);
    }

    public fun nested_struct_updates(v: u64): u64 {
        // Simulate nested struct updates with local variables
        let mut outer = v;
        let mut inner = outer;

        // Nested manipulations
        outer = outer + 3;
        inner = inner * 2;
        inner = inner - 1;

        // Final computation involving both
        let combined = outer + inner;
        combined
    }

    public fun test_nested_struct_updates() {
        let result = nested_struct_updates(10);
        assert!(result == (10 + 3) + (10 * 2 - 1), 104);
    }
}

//# run 0xabcde::interaction_tests::test_fetch_and_recompute
//# run 0xabcde::interaction_tests::test_complex_arithmetics
//# run 0xabcde::interaction_tests::test_variable_reassignment_stability
//# run 0xabcde::interaction_tests::test_nested_struct_updates