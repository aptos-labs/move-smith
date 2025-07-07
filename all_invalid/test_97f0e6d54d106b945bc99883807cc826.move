//# publish
module 0xdeadbeef::interaction_tests {
    fun bar() {
        // Placeholder for bar function
        assert!(true, 0);
    }

    //# run 0xdeadbeef::interaction_tests::conditional_assign_and_multiply
    fun conditional_assign_and_multiply(a: u64, b: u64, c: bool): u64 {
        if (c) {
            a = b;
        };
        let t = a * 4;
        bar();
        let t2 = a * 5;
        t + t2
    }

    //# run 0xdeadbeef::interaction_tests::variable_loop_test
    public fun variable_loop_test(init_value: u64): u64 {
        let mut sum = 0;
        let mut i = 0;
        let limit = init_value % 10 + 10; // dynamic loop count between 10 and 19
        while (i < limit) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    //# run 0xdeadbeef::interaction_tests::inline_function_pass
    inline fun multiply_by_two(x: u64): u64 {
        x * 2
    }

    inline fun multiply_by_three(x: u64): u64 {
        x * 3
    }

    public fun compute_sum(f: |u64| u64, g: |u64| u64, value: u64): u64 {
        f(value) + g(value)
    }

    //# run 0xdeadbeef::interaction_tests::test_inline_functions
    public fun test_inline_functions() {
        let result = compute_sum(|x| multiply_by_two(x), |x| multiply_by_three(x), 7);
        assert!(result == 7 * 2 + 7 * 3, 0);
    }
}

//# run 0xdeadbeef::interaction_tests::conditional_assign_and_multiply --args 15 25 true
//# run 0xdeadbeef::interaction_tests::conditional_assign_and_multiply --args 15 25 false

//# run 0xdeadbeef::interaction_tests::variable_loop_test --args 12

//# run 0xdeadbeef::interaction_tests::test_inline_functions