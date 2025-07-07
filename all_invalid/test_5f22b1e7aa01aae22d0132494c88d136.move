//# publish
module 0xabcde::test_module {
    fun foo(n: u64): u64 {
        let result = 2; // initial value
        let mut i = 0;
        while (i < n) {
            result = 3; // update during loop
            i = i + 1;
        }
        result
    }

    public fun run_tests() {
        // Test initial value when n is zero
        assert!(foo(0) == 2, 100);
        // Test update during loop when n is one
        assert!(foo(1) == 3, 101);
        // Additional check for multiple iterations
        assert!(foo(5) == 3, 102);
    }
}

//# run 0xabcde::test_module::run_tests