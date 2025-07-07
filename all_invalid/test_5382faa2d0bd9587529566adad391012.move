//# publish
module 0xabc123::logic_tests {
    public fun negation_and_assignment(p: bool): bool {
        // Apply negation and compound assignment, then combine with logical AND and OR to test behavior
        (!p && {p = p && true; p}) || {p = !p; !p}
    }

    public fun run_negation_and_assignment_tests() {
        let result_true = negation_and_assignment(true);
        let result_false = negation_and_assignment(false);
        // The function tests behavior with true input; result should be false
        assert!(result_true == false, 1);
        // The function tests behavior with false input; result should be true
        assert!(result_false == true, 2);
    }
}

//# run 0xabc123::logic_tests::run_negation_and_assignment_tests

//# publish
module 0xabc123::inline_fn_tests {
    // Inline function that calls a provided function pointer and returns sum of specific args
    inline fun compute_sum(g: |u64, u64, u64, u64| u64, a: u64, b: u64, c: u64, d: u64): u64 {
        g(a, b, c, d)
    }

    public fun test_inline_fn() {
        assert!(compute_sum(|x, y, z, q| x + y + z + q, 5, 15, 25, 35) == 80, 0);
        assert!(compute_sum(|x, y, z, q| y * z, 1, 2, 3, 4) == 6, 1);
    }
}

//# run 0xabc123::inline_fn_tests::test_inline_fn

//# publish
module 0xabc123::loop_counter {
    public fun count_up() {
        let mut counter = 0;
        while (true) {
            if (counter >= 5) break;
            counter = counter + 1;
        }
        // Verify counter reaches 5 after loop
        assert!(counter == 5, 42);
    }

    public fun count_down() {
        let mut counter = 10;
        while (true) {
            if (counter <= 5) break;
            counter = counter - 1;
        }
        // Verify counter reaches 5 after loop
        assert!(counter == 5, 43);
    }
}

//# run 0xabc123::loop_counter::count_up
//# run 0xabc123::loop_counter::count_down