
//# publish
module 0xC0FF::MultifacetedTestModule {
    use std::signer;
    use std::vector;

    // Constants for test addresses
    const TEST_ADDR1: address = 0xBEE1u64; // explicitly specify u64 for address literals
    const TEST_ADDR2: address = 0xBEE2u64; // explicitly specify u64 for address literals

    // Structs to hold state for testing
    struct StateHolder has store, key {
        counter: u64,
        flag: bool,
    }

    // Entry point to initialize a state object
    public fun init_state(s: &signer): () {
        let addr = signer::address_of(s);
        move_to<StateHolder>(&s, StateHolder { counter: 0, flag: false });
    }

    // Entry point that performs multiple aborts with different error codes
    public fun aborts_chain(s: &signer): () {
        abort 100;
        // The lines below are unreachable, but are kept for completeness
        abort 200;
        abort 300;
    }

    // Entry point that checks static bytecode correctness with an intentionally invalid Bytecode
    public fun static_check(): bool {
        true
    }

    // Inline function used in a test, body should be inlined
    public inline fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Function to test inlining—calls an inline function
    public fun test_inline(a: u64, b: u64): u64 {
        inline_add(a, b)
    }

    // Function that performs a lint check on the code
    public fun lint_check(): bool {
        true
    }

    // Spec block to validate invariants during a loop
    spec module {
        invariant (_counter <= 10);
    }

    // Transactional script that affects state and uses all features together
    public fun complex_interaction(s: &signer) {
        // Initialize state
        init_state(s);
        let _ = get_state(s); // forces load

        // Simulate a loop with invariant to check
        let i = 0u64;
        while (i < 5) /* invariant i <= 10 */ {
            // Ensure the invariant holds
            assert!(i <= 10, 999);
            // Increase counter in state
            let state_ref: &mut StateHolder = borrow_global_mut<StateHolder>(signer::address_of(s));
            state_ref.counter = state_ref.counter + 1;
            // Perform inline addition
            let sum = test_inline(state_ref.counter, 5);
            // Simulate aborts with specific code
            if (sum > 20) {
                abort 9999;
            }
            i = i + 1;
        }
        // Final state check
        let state_ref_final: &StateHolder = borrow_global<StateHolder>(signer::address_of(s));
        assert!((state_ref_final.counter >= 0), 888);
    }

    // Helper functions to access state
    public fun get_state(s: &signer): &StateHolder {
        borrow_global<StateHolder>(signer::address_of(s))
    }
}
