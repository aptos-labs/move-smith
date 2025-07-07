
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

    public fun foo(): u8 {
        // Outer x
        let x = 1u8;
        // Property set with expressions:
        let property_set = ShadowState {
            x: x + 1,
            y: x * 2,
            nested_vals: vector[0u8, 1u8, x],
        };

        // Inner function shadows x, modifies it, then returns a value
        let inner = |x: u8| u8 {
            // Shadowing outer x variable, simulating capture with argument shadowing
            let x = x + 1;
            x // returns 2 on first call
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
            result = x;
        } else {
            // Early return here, forcing compiler to recognize uninitialized use risk if any
            return 42u8;
        };

        // Using dependent vector module implicitly to test auto dependency maintenance
        let v: vector<u8> = vector[10u8, 20u8, 30u8];
        let _ = *vector::borrow(&v, 1);

        // Final result should be x which is 3
        result
    }
}


//# run 0xCAFE::ComplexShadowing::foo


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
// 74665b166542421d38b99e7f0be094fb: Use the `require_move_2_and_advance` function to check for the presence of the 'move_2' feature in your code.
// 9215ae1df667395735358a83241850e3: Test that variables declared before an if-else statement are correctly recognized as potentially uninitialized if a return occurs in one branch.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
