
//# publish
module 0xDEAD::TestInteractions {
    use std::signer;
    use std::abort;
    use std::vector;

    // Internal function that is not callable externally
    fun internal_helper(): u64 {
        42
    }

    // Native function placeholder prototype: assume implemented externally
    native public fun external_native_function(): bool;

    // Entry point script that invokes the module functions and tests control flow
    public fun run_tests() {
        // Local variable outside loop
        let a = 1u64;
        // Shadowed variable inside loop
        let b = 10u64;

        // Loop with variable shadowing and variable assignments
        let c = 0u64;
        let c_mut = c;
        while (a < 5) {
            // Shadowing
            let a = a + 1;
            // Inside while, assign to mutable variable declared outside
            c_mut = a + b;
            // Call internal function (should not be callable from outside, but valid here)
            let _ = internal_helper(); // internal function call
            a
        };
        // Variable outside loop remains unchanged
        let _ = a;
        let _ = c_mut;

        // Call external native function (assumes implemented outside)
        let _ = external_native_function();

        // Test abort within an `if`
        if (a > 5) {
            abort(999);
        } else {
            // Should execute normally
            let _ = a;
        };

        // Test explicit abort in nested code
        if (b > 8) {
            let _ = abort(7); // This abort terminates execution
        } else {
            // unreachable
            let _ = 0;
        };

        // Sequencing with aborts
        let _ = (abort(1), 100;  // Should abort before returning 100
        );
        // This code is unreachable due to abort above

        // Variable assignment involving an abort expression
        let d = if (false) {
            abort(55)
        } else {
            55
        };
        let _ = d;

        // Variable shadowing after abort sequence
        let e = 0u8;
        // Sequence with abort
        let _ = (if (false) { abort(999) } else { 1u8 }, e);
        // The above aborted, so subsequent code is not executed
        // No code beyond this point is valid (simulate propagation)

        // Call internal helper from script, should not be accessible externally
        // Not called here as internal, but to confirm internal status: skip

        // Call native function (assuming external implementation)
        let _ = external_native_function();

        // Vector usage with complex types
        let v: vector<u8> = vector::empty();
        vector::push_back(&v, 1);
        vector::push_back(&v, 2);

        // Borrow and assert (simulate checks)
        let _ = *vector::borrow(&v, 0);
        let _ = *vector::borrow(&v, 1);
    }

    // Internal function not accessible externally
    fun internal_secret() {
        // just a dummy internal function
    }
}


//# run 0xDEAD::TestInteractions::run_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 0182c1793cb068bc0c1b7f0324c594d2: Test that abort expressions inside code blocks used as operands in binary operations are correctly detected and handled during execution.
// 0dbce85205ae1679273cb52846e30321: Test that abort propagation and sequencing expressions correctly handle aborts and unreachable code in Move functions.
// 36c72e3edbdbc4d4c017c081addfe2f5: Annotate spec functions with the 'native' keyword to indicate that their implementation is external or unavailable.
