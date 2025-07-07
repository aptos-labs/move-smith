//# publish
module 0xabcde::copy_reassignment_test {
    fun check_equality_after_reassignment(initial_value: u64): bool {
        let original = initial_value;
        let copy = original;
        let another_copy = copy;

        // Reassign 'copy', breaking previous reference chain
        // The previous copies should remain unaffected since Move variables are not references but copies
        // However, reassigning does not mutate the original 'original', just updates 'copy'
        // To mimic breaking the chain, we just reassign 'copy'
        // This test ensures 'original' and 'another_copy' stay unchanged and are still equal
        let copy = initial_value + 10; 

        // Check that 'original' and 'another_copy' remain equal to initial_value
        // and unaffected by 'copy' reassignment
        original == initial_value && another_copy == initial_value
    }

    public fun run_tests(): bool {
        check_equality_after_reassignment(42)
    }
}

//# run 0xabcde::copy_reassignment_test::run_tests