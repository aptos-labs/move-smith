
//# publish
module 0xC0FF::MultifacetedTestModule {
    use std::signer;
    use std::vector;

    // Constants for test addresses
    const TEST_ADDR1: address = 0xBEE1;
    const TEST_ADDR2: address = 0xBEE2;

    // Structs to hold state for testing
    struct StateHolder has store, key {
        counter: u64,
        flag: bool,
    }

    // Entry point to initialize a state object
    public fun init_state(s: signer): () {
        let addr = signer::address_of(&s);
        move_to<StateHolder>(&s, StateHolder {counter: 0, flag: false});
    }

    // Entry point that performs multiple aborts with different error codes
    public fun aborts_chain(s: signer): () {
        // Intentional aborts to test VM abort handling
        abort 100;
        abort 200;
        abort 300; // Only first abort should execute
    }

    // Entry point that checks static bytecode correctness with an intentionally invalid Bytecode
    // (In the test, we assume this would be a static bytecode at module compile time)
    public fun static_check(): bool {
        // static verification would occur during compilation; returning true here as placeholder
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
    // For demonstration, this just returns true, but assume static analysis is performed
    public fun lint_check(): bool {
        // In real tests, we'd invoke static analysis tools
        true
    }

    // Spec block to validate invariants during a loop
    spec module {
        invariant (counter <= 10);
    }

    // Transactional script that affects state and uses all features together
    public fun complex_interaction(s: signer) {
        let _ = init_state(s);
        // Simulate a loop with invariant to check
        let i = 0u64;
        while (i < 5) {
            // Ensure the invariant holds
            assert!(i <= 10, 999);
            // Increase counter in state
            let state_ref: &mut StateHolder = borrow_global_mut<StateHolder>(signer::address_of(&s));
            state_ref.counter = state_ref.counter + 1;
            // Perform inline addition
            let sum = test_inline(state_ref.counter, 5);
            // Simulate aborts with specific code
            if (sum > 20) {
                abort 9999; // This may not execute if condition is false
            };
            i = i + 1;
        };
        // Final state check
        let state_ref_final: &StateHolder = borrow_global<StateHolder>(signer::address_of(&s));
        assert!((state_ref_final.counter >= 0), 888);
    }
}


//# run 0xC0FF::MultifacetedTestModule::aborts_chain --signers 0xBEE1


//# run 0xC0FF::MultifacetedTestModule::init_state --signers 0xBEE2


//# run 0xC0FF::MultifacetedTestModule::static_check


//# run 0xC0FF::MultifacetedTestModule::test_inline --args 123u64 456u64 --signers 0xBEE1


//# run 0xC0FF::MultifacetedTestModule::complex_interaction --signers 0xBEE2


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 1630878bb07f0e61d64057399656ba48: Test that the Move function correctly handles multiple aborts and continues execution to produce the expected final result.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// 1011b8aa32f48fef72a832a6a7a35814: Write Move code that is statically checked for bytecode-level correctness before execution
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// 84f7647c2caf95d50c61740a458f0b0f: Run model AST lint checks.
// 08082b21b4090d159c6641a7a7311704: Include only `invariant` conditions inside `spec` blocks to ensure proper validation of loop invariants.
