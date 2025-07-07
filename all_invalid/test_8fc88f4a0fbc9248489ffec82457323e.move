//# publish
module 0xabcde::nested_call_tests {
    // A simple module with multiple functions calling each other to test nested function calls and return values.
    fun multiply_by_two(x: u64): u64 {
        x * 2
    }

    fun add_three(x: u64): u64 {
        x + 3
    }

    fun combined_operations(x: u64): u64 {
        let result = multiply_by_two(x);
        add_three(result)
    }

    // A recursive-like sequence of calls with different orderings.
    fun chain_calls(x: u64): u64 {
        let a = multiply_by_two(x);
        let b = add_three(a);
        add_three(b)
    }

    public fun run() {
        // Testing the combined_operations function
        assert!(combined_operations(5) == 13, 0);
        // Testing the chain_calls function
        assert!(chain_calls(7) == 17, 1);
    }
}

//# run 0xabcde::nested_call_tests::run