
//# publish
module 0xCAFE::ComplexShadowing {
    use std::vector;

    public fun require_move_2_and_advance(): bool {
        // This mimics checking a "feature" called move_2 and advances if available.
        // Dummy implementation: always return true.
        true
    }

    struct ShadowState has copy, drop, store {
        x: u8,
        y: u8,
        nested_vals: vector<u8>,
    }

    // Inner function moved outside of foo, since Move does not allow nested functions
    fun inner(x: u8): u8 {
        let x = x + 1;
        x
    }

    public fun foo(): u8 {
        // Outer x
        let x = 1u8;
        // Property set with expressions:
        let property_set = ShadowState {
            x: x + 1,
            y: x * 2,
            nested_vals: vector[0u8, 1u8, x],
        };

        // Call the inner function with outer x, change outer x to the returned value (2)
        let x = inner(x);

        // Call inner again with updated x which is 2, expect 3
        let x = inner(x);

        // The final x should be 3 here

        // Use the property_set to prevent compiler from removing it and to test property field access
        let sum_props = property_set.x + property_set.y + *vector::borrow(&property_set.nested_vals, 2);

        // Check feature presence (require_move_2_and_advance)
        let _feature_ok = require_move_2_and_advance();

        // Test variables declared before if-else statement used properly with early return on one branch
        let result = 0u8;
        if (x == 3) {
            // Explicit reassignment (no mutation possible, so shadowing again)
            let result = x;
            result
        } else {
            // Early return here, forcing compiler to recognize uninitialized use risk if any
            return 42u8;
        };

        // Using dependent vector module implicitly to test auto dependency maintenance
        let v: vector<u8> = vector[10u8, 20u8, 30u8];
        let _ = *vector::borrow(&v, 1);

        // Final result should be x which is 3
        x
    }
}




//# run 0xCAFE::ComplexShadowing::foo
