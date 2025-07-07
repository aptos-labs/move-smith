//# publish
module 0xabcde::test_module {
    /// A simple cyclic function that should return the input value without modification.
    fun cyclic_test(p: u64): u64 {
        let temp1 = p;
        let temp2 = temp1;
        // reassign p to temp2
        let p = temp2;
        p
    }

    /// A runner function to test the cyclic behavior
    public fun run_cyclic_test() {
        let test_value = 12345u64;
        let result = Self::cyclic_test(test_value);
        // In actual tests, assertions would be here, but omitted per instructions.
    }
}

//# run 0xabcde::test_module::run_cyclic_test

    //# run 0xabcde::test_module::cyclic_test --args 67890 --signers 0xabcde