
//# publish
module 0xBABE::TraceTest {
    use std::debug;

    // Global variable to track if loop executed
    struct LoopFlag has key {
        executed: bool,
    }

    // Initialize the flag in global storage
    public fun init_flag(account: &signer) {
        move_to<LoopFlag>(account, LoopFlag { executed: false });
    }

    // Function with generic parameter to test type recognition
    public fun generic_type_test<T>(value: T): T {
        // Log type info (mocked as debug message for illustration)
        debug::print(&b"generic_type_test called"[..]);
        value
    }

    // Function with type alias starting with an identifier
    type AliasType = u8;

    public fun type_alias_test(x: AliasType): u8 {
        // Log type info
        debug::print(&b"type_alias_test called"[..]);
        x
    }

    // Function that triggers an impure construct (resource mutation)
    public fun impure_operation(account: &signer) {
        // Simulate an impure operation by moving a resource
        move_to<TraceFlag>(account, TraceFlag { count: 1 });
        // After this, resource is in global storage (impure)
    }

    // Helper to clear resource for clean tests
    public fun clear_impure_state(account: &signer) {
        if (exists<TraceFlag>(signer::address_of(account))) {
            move_from<TraceFlag>(signer::address_of(account));
        }
    }

    // Function with nested calls leading to impure operation
    public fun nested_call_chain(account: &signer) {
        trace_chain_step1(account);
    }

    fun trace_chain_step1(account: &signer) {
        trace_chain_step2(account);
    }

    fun trace_chain_step2(account: &signer) {
        impure_operation(account);
    }

    // Function with a for loop where start > end: should not execute body
    public fun loop_test(flag_ptr: &mut bool) {
        // Range start > end, so loop body should not run
        for (i in 10..5) {
            *flag_ptr = true; // Should not set this
        }
    }

    // Main test runner
    public fun run_tests(account: &signer) {
        // Reset flag
        let flag_exists = exists<LoopFlag>(signer::address_of(account));
        if (flag_exists) {
            move_from<LoopFlag>(signer::address_of(account));
        }
        // Initialize flag
        init_flag(account);
        // Test generic type handling
        let _x = generic_type_test(42u8);
        // Test type alias recognition
        let _x2 = type_alias_test(255u8);
        // Test nested call chain to impurity
        nested_call_chain(account);
        // Check that impure resource exists now
        assert!(exists<TraceFlag>(signer::address_of(account)), 1001);
        // Test loop does not run
        let loop_flag = false;
        loop_test(&mut loop_flag);
        // Confirm loop body not executed
        assert!(!loop_flag, 1002);
        // Clear impurity state for future tests
        clear_impure_state(account);
    }
}

// Helper resource for impure operation
struct TraceFlag has key {
    count: u64,
}


//# run 0xBABE::TraceTest::run_tests --signers 0xC0DE


// Featurres:
// 8ee9cdbbaf8cbaff696ba611c081457b: View the call chain that led to an impure construct being used in a specification, pinpointing the source of the violation.
// 38d9f19717f4d38f588ea3ae0f8eb41f: Identify a type starting with an identifier, such as a type name or generic parameter.
// e32f8b85b1e8aa0f9c73491778f5699b: Test that a for loop with an empty range (where the start is greater than the end) does not execute its body.
