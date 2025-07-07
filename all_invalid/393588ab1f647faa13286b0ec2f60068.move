//# publish
module 0xBADD::AdvancedFeatureTest {
    // Just to exercise various features, no external use
    use std::signer;
    use std::vector;

    // Declare some constants to test literal suffixes
    const LITERAL_U8: u8 = 255u8;
    const LITERAL_U16: u16 = 65535u16;
    const LITERAL_U32: u32 = 4294967295u32;
    const LITERAL_U64: u64 = 18446744073709551615u64;

    // Module struct to hold some internal state
    struct State has key {
        counter: u64,
        name: vector<u8>,
        active: bool,
    }

    // Declare internal function (private) for internal logic
    fun internal_increment(state: &mut State): () {
        state.counter = state.counter + 1u64;
    }

    // Declare external function, but internal functions can be called within
    public fun create_state(s: signer, name: vector<u8>): &mut State {
        move_to<State>(&s, State {counter: 0u64, name, active: true});
        borrow_global_mut<State>(signer::address_of(&s))
    }

    // Internal function with skip lint check attribute
    // lint_skip]
    fun internal_skip_check() {
        // Function body is irrelevant, just to test attribute
    }

    // Script entry point - initiate state and perform internal operation
    public fun script_entry(s: signer, name: vector<u8>) {
        let state_ref = create_state(s, name);
        internal_increment(state_ref);
        internal_skip_check();
    }

    // Internal function that shadows public variable
    fun shadow_variable() {
        let x = 123u64;
        let x = x + 1u64; // shadowing previous x
        assert!(x == 124u64, 999);
    }

    // Function with variable outside loop, modified inside loop
    fun variable_outside_while() {
        let count = 0u64;
        let limit = 3u64;

        while (count < limit) {
            let local_val = count * 10u64; // local variable in loop
            count = count + 1u64;
        };
        // After loop, count should be limit
        assert!(count == limit, 1000);
    }

    // Function with inner variable shadowing outer
    fun shadow_outer_variable() {
        let x = 10u16;
        if (x > 5u16) {
            let x = x + 5u16;  // shadowing outer x
            assert!(x == 15u16, 1001);
        };
        // Ensure outer x unchanged
        assert!(x == 10u16, 1002);
    }

    // External function invoking internal functions & attributes
    public fun test_external_calls() {
        // Call internal function within module
        internal_skip_check();
        // Call internal function for increment
        let s = signer::borrow_address();
        let state_ref = create_state(s, b"test"_vector);
        internal_increment(state_ref);
    }

    // Function with attribute to skip lint
    // lint_skip]
    public fun skip_lint_test() {
    }

    // Function testing variable declaration in nested scopes
    public fun nested_scopes() {
        let outer_var = 50u8;
        if (outer_var > 20u8) {
            let inner_var = outer_var - 10u8;
            assert!(inner_var == 40u8, 1003);
        };
        // Confirm outer_var unchanged
        assert!(outer_var == 50u8, 1004);
    }
}

// -- Run command should be fixed with proper argument syntax --
// Example corrected usage (not part of code):
// task run 0xBADD::AdvancedFeatureTest::script_entry --signers 0xDEAD --args "0xdeadbeef"
