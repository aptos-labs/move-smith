//# publish
module 0xCAFE::TestStructsAndInline {
    use std::signer;

    struct PositionalStruct has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct RegularStruct has copy, drop, store {
        a: u128,
        b: u128,
    }

    // Inline function that captures and modifies a local variable
    public inline fun add_to_x(x: &mut u64, to_add: u64) {
        *x = *x + to_add;
    }

    public fun test(): u64 {
        let mut x = 0u64;

        // Define positional struct instance
        let _pos_struct = PositionalStruct {x: 10, y: 20};

        // Define regular struct instance
        let _reg_struct = RegularStruct {a: 100, b: 200};

        let i = 0u64;
        // Loop with an invariant: i <= 5, and x >= i always holds
        while (i < 5) {
            // Invariant check expressions are often no-op but we include as dummy assignments and assertions:
            assert!(i <= 5, 999);
            assert!(*(&x) >= i, 999);

            add_to_x(&mut x, 2);

            // Increment i
            let new_i = i + 1;
            // Shadow i so loop condition updates correctly for demonstration
            i = new_i;
        };

        x
    }
}

//# run 0xCAFE::TestStructsAndInline::test

// Featurres:
// 0a4bf8b517a6f7a4362afc75ce952189: Declare structs with fields either as regular or positional fields.
// 206ebfe6b421d8dcf6d3ea42bdb5b167: Test that the inline function correctly captures and modifies the local variable `x` when called within the `test` function.
// 82a0a59b494fa982d851f402af597651: Include loop invariants within loops to ensure certain conditions hold throughout loop execution.
