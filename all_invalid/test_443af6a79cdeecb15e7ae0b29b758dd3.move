//# publish
module 0xAABBCC::test_module {
    // Function to return the value of a variable after assignment, used to verify correct returns
    public fun check_value(val: u64): u64 {
        let assigned = val;
        assigned
    }

    // Runner function to call check_value
    public fun run_check() {
        // No args needed, just return a test value
        check_value(42)
    }
}

//# run 0xAABBCC::test_module::run_check

//# run
script {
    fun main() {
        let result = 0;
        // Call the module function directly
        result = 0xAABBCC::test_module::check_value(100);
        // result should be 100
        // You can perform assertions here if needed for testing
    }
}

//# run 0xAABBCC::test_module::check_value --args 123

//# publish
module 0xDDEEFF::numeric_loop {
    public fun test_underflow() {
        // Test that looping within u64 bounds does not overflow
        let mut i = 1u64;
        let mut j = 0u64;
        while (j < 8) {
            i = i * 2; // should stay within u64 bounds
            j = j + 1;
        }
        // Optional: return or just finish
    }

    public fun test_u64_max() {
        // Verify that multiplying near u64 max causes overflow – we expect this to fail if unchecked
        let i = 0xffffffffffffffff; // max u64 value
        // Multiplying by 2 should overflow
        // For the test, just attempt a potent multiplication
        let _overflow_test = i * 2;
    }
}

//# run 0xDDEEFF::numeric_loop::test_underflow
//# run 0xDDEEFF::numeric_loop::test_u64_max

//# publish
module 0x112233::logical_test {
    public fun evaluate_logs(a: bool, b: bool): u64 {
        let result = 1;
        if (a) {
            result = result * 2; // Logic AND part, with side effect
        }
        if (b) {
            result = result * 3; // Logic OR part, with side effect
        }
        result
    }
}

//# run
script {
    use 0x112233::logical_test;
    fun main() {
        // Test with different boolean combinations
        assert!(logical_test::evaluate_logs(false, false) == 1, 1);
        assert!(logical_test::evaluate_logs(false, true) == 3, 2);
        assert!(logical_test::evaluate_logs(true, false) == 2, 3);
        assert!(logical_test::evaluate_logs(true, true) == 6, 4);
    }
}

//# run 0x112233::logical_test::evaluate_logs --args false false
//# run 0x112233::logical_test::evaluate_logs --args false true
//# run 0x112233::logical_test::evaluate_logs --args true false
//# run 0x112233::logical_test::evaluate_logs --args true true