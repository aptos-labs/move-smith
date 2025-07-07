//# publish
module 0xabcde::apply_test {
    fun apply_repeatedly<T: copy + drop>(
        f: |T|T,
        times: u64,
        initial: T
    ): T {
        let mut result = initial;
        let mut i = 0;
        while (i < times) {
            result = f(result);
            i = i + 1;
        }
        result
    }

    public fun run_apply_test() {
        // Test applying a function that doubles the value 5 times starting from 1
        let final_value = apply_repeatedly(|x| x * 2, 5, 1);
        // Expected: 2^5 * 1 = 32
        assert(final_value == 32, 0);
    }

    public fun test_variable_reassignment() {
        let mut a = 10;
        let b = a;
        let c = b + 5;
        a = c; // reassignment without errors
        assert(a == 15, 0);
    }
}

//# run 0xabcde::apply_test::run_apply_test
//# run 0xabcde::apply_test::test_variable_reassignment