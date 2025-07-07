//# publish
module 0xabcde::test_module {
    // Function that returns the input value directly, with no side effects
    public fun dead(n: u64): u64 {
        n = n; // No side effects, just reassign to itself
        n
    }

    // Runner function to test multiple inputs
    public fun run_tests() {
        let test_values = [0u64, 42u64, 999u64, 12345u64];
        let mut results = vector::empty<u64>();
        let len = vector::length(&test_values);
        let mut i = 0;
        while (i < len) {
            let val = *vector::borrow(&test_values, i);
            let res = Self::dead(val);
            vector::push_back(&mut results, res);
            i = i + 1;
        }
    }
}

//# run 0xabcde::test_module::run_tests