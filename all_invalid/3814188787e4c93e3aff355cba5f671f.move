// 1. Generate a diagnostic error message when an unexpected token is encountered during parsing

// The following script contains a syntax error (unexpected token), 
// which should cause the Move compiler to emit a diagnostic error message during parsing.

//# run
script {
    fun main() {
        let x = 10;;
        let y == 20; // ERROR: "==" instead of "=" for assignment
        let z = x + y;
    }
}

// 2. Test that the Move language correctly parses and handles a `loop` statement immediately followed by a `break`.

//# run
script {
    fun main() {
        let mut count = 1;
        loop {
            break;
            count = count + 1; // This should never execute
        };
        // After loop, do a simple check
        count = count + 10;
    }
}

// 3. Test that the calculator module correctly processes sequential input commands to perform 
// addition and subtraction operations, maintaining and updating its internal state accordingly.

//# publish
module 0xCAFE::Calculator {
    use std::signer;
    // A calculator state stored per account
    struct State has key {
        value: u64,
    }

    // Initialize Calculator for an account
    public fun init(account: &signer) {
        assert!(!exists<State>(signer::address_of(account)), 100);
        move_to(account, State { value: 0 });
    }

    // Add to calculator state
    public fun add(account: &signer, operand: u64) {
        let state = borrow_global_mut<State>(signer::address_of(account));
        state.value = state.value + operand;
    }

    // Subtract from calculator state
    public fun subtract(account: &signer, operand: u64) {
        let state = borrow_global_mut<State>(signer::address_of(account));
        assert!(state.value >= operand, 101);
        state.value = state.value - operand;
    }

    // Get the value
    public fun get(account_addr: address): u64 {
        borrow_global<State>(account_addr).value
    }

    // Run add/subtract sequence test
    public fun run_sequence(account: &signer) {
        // Initialize
        Self::init(account);
        // Adding 20
        Self::add(account, 20);
        let v1 = Self::get(signer::address_of(account));
        // Subtract 5
        Self::subtract(account, 5);
        let v2 = Self::get(signer::address_of(account));
        // Add 50
        Self::add(account, 50);
        let v3 = Self::get(signer::address_of(account));
        // Final value v3 should be 65
    }

}

//# run 0xCAFE::Calculator::run_sequence --signers 0xCAFE


// Featurres:
// 6d4255c438d053ad41e85f2a5e2fffae: Generate a diagnostic error message when an unexpected token is encountered during parsing
// 62241665497edacd4b34bf3a1477ce1b: Test that the Move language correctly parses and handles a `loop` statement immediately followed by a `break`.
// 10d106d881100bf94dc794f624cb5369: Test that the calculator module correctly processes sequential input commands to perform addition and subtraction operations, maintaining and updating its internal state accordingly.
