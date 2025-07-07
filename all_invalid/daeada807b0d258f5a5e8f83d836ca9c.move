//# publish
module 0xA550C18::AccessTest {
    // This module defines functions with different visibility to test module identifier accesses.

    // Public function
    public fun public_function(): u64 {
        42
    }

    // Script function (executable only from scripts, can't be called from other modules)
    script fun script_function(): u64 {
        24
    }

    // Friend function: only accessible from friend modules (not used here, but declared)
    friend fun friend_function(): u64 {
        11
    }

    // Internal function
    fun internal_function(): u64 {
        7
    }

    // Runner function to call all accessible functions with no arguments.
    public fun runner(): u64 {
        let v1 = public_function();
        // script_function cannot be called from a module, so not called here.
        let v2 = internal_function();
        // friend function not called (no friend modules).
        v1 + v2
    }
}

//# run 0xA550C18::AccessTest::runner --signers 0xA550C18


//# publish
module 0xA550C18::LetBindingsTest {
    // Testing let bindings with optional type annotations and initializers.

    public fun let_bindings_runner(): u64 {
        // Let with initializer and type annotation
        let x: u64 = 10;

        // Let with initializer without type annotation
        let y = 15;

        // Let without initializer with type annotation, initialized later
        let z: u64;
        z = x + y;

        // Let without type annotation and without initializer (should be an error)
        // invalid: let w; // -- commented out since invalid Move syntax

        // Let with multiple anchoring
        let a: u8 = 2;
        let b: u8 = 3;

        // Compute sum with mixed types converted explicitly
        let sum: u64 = (a as u64) + (b as u64) + z;

        sum
    }
}

//# run 0xA550C18::LetBindingsTest::let_bindings_runner


//# publish
module 0xA550C18::WhileLoopInvariantTest {
    // This module tests the insertion of loop invariant conditions in `while` loops.

    // A function that counts down from n to 0, asserting the loop invariant n >= 0 (naturally true)
    public fun countdown(n: u64): u64 {
        let mut i = n;
        while (i > 0) {
            // Loop invariant inserted as require: i <= n and i >= 0 (u64 always >=0)
            assert!(i <= n, 1);
            // Decrement
            i = i - 1;
        };
        i
    }

    // Another while loop with a different invariant: sum never decreases incorrectly.
    public fun sum_accumulate(n: u64): u64 {
        let mut i = 0;
        let mut sum = 0;
        while (i < n) {
            // Loop invariant ensures sum is the sum of integers from 0 to i-1
            assert!(sum == i * (i - 1) / 2 || i == 0, 2);
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    public fun runner(): u64 {
        let v1 = countdown(10);
        let v2 = sum_accumulate(5);
        v1 + v2
    }
}

//# run 0xA550C18::WhileLoopInvariantTest::runner --signers 0xA550C18


//# run
script {
    use 0xA550C18::AccessTest;
    use 0xA550C18::LetBindingsTest;
    use 0xA550C18::WhileLoopInvariantTest;

    fun main(account: signer) {
        let r1 = AccessTest::public_function();
        let r2 = AccessTest::runner();
        let r3 = LetBindingsTest::let_bindings_runner();
        let r4 = WhileLoopInvariantTest::countdown(3);
        let r5 = WhileLoopInvariantTest::sum_accumulate(4);
        let r6 = WhileLoopInvariantTest::runner();

        // No assertions required, just run
        let _ = (r1, r2, r3, r4, r5, r6);
    }
}