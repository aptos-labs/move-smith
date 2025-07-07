//# publish
module 0xAABB::var_tests {
    // Function to check variable stability when outer variable is not changed
    public fun check_unmodified(x: u64): u64 {
        let y = x;
        let z = y;
        z
    }
}

//# run
script {
    use 0xAABB::var_tests::check_unmodified;
    fun main() {
        let initial_value = 999;
        // Call the function with initial_value
        let result = check_unmodified(initial_value);
        // Assert that result equals initial_value to verify variables are unchanged
        assert!(result == 999, 100);
    }
}

//# publish
module 0xDDEE::conditional_edge {
    public fun decide(flag: bool, a: u64, b: u64): u64 {
        if (flag) {
            a
        } else {
            b
        }
    }
}

//# run 0xDDEE::conditional_edge::decide --args true 42 99
//# run 0xDDEE::conditional_edge::decide --args false 42 99

//# publish
module 0xFFEE::assert_on_value {
    public fun check_value(x: u64, expected: u64) {
        assert!(x == expected, 200);
    }
}

//# run 0xFFEE::assert_on_value::check_value --args 0 0
//# run 0xFFEE::assert_on_value::check_value --args 123 123
//# run 0xFFEE::assert_on_value::check_value --args 45 100

//# publish
module 0xBEEF::loop_test {
    public fun loop_and_update(n: u64): u64 {
        let result = 1;
        let mut i = 0;
        while (i < n) {
            // Each iteration, update result based on i
            if (i % 2 == 0) {
                result = result + i;
            } else {
                result = result + (i * 2);
            }
            i = i + 1;
        }
        result
    }

    public fun test() {
        assert!(loop_and_update(0) == 1, 300);
        assert!(loop_and_update(3) == 1 + 0 + 2 + 6, 301); // 1 + 0 + 2 + 6 = 9
        assert!(loop_and_update(5) == 1 + 0 + 2 + 6 + 4 + 10, 302); // sum: 1 + 0 + 2 + 6 + 4 +10 = 23
    }
}

//# run 0xBEEF::loop_test::test