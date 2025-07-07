
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;
    use std::vector;

    const SHIFT_LEFT_8: u8 = 1 << 8; // Should be 0, as shifting beyond 7 yields zero
    const SHIFT_RIGHT_8: u8 = 128 >> 8; // Should be 0

    // Internal function, should not be accessible from outside
    fun internal_private_function(): u64 {
        42
    }

    // Public function invoking various features
    public fun entry_point(
        s: signer,
        flag: bool,
        outer_x: u8,
        outer_y: u8,
        nested_value: u8,
        shift_left_const: u8,
        shift_right_const: u8
    ): (u64, bool, u8, u8, u8, u8, u8) {
        // Call internal function internally (allowed)
        let _internal_result = internal_private_function();

        // Variable declarations
        let x = outer_x;
        let y = outer_y;

        // Shadowed variable
        let shadowed_value = nested_value;

        // Loop with local variables
        let counter = 0u64;
        while (counter < 3) {
            // Shadow a variable within the loop
            let shadowed_value = shadowed_value + 1;
            // Outer scope shadowed_value remains unchanged
            counter = counter + 1;
        };

        // Variable outside loop
        let result_x = x;
        let result_y = y;

        // Verify that shadowed_value outside loop remains unchanged
        let final_shadowed_value = shadowed_value;

        // Test constant expressions involving shift operations
        let shifted_left = shift_left_const;
        let shifted_right = shift_right_const;

        // Final return combining all
        (
            internal_private_function(),
            flag,
            result_x,
            result_y,
            final_shadowed_value,
            shifted_left,
            shifted_right
        )
    }

    // Entry point to test access restriction (attempt to call private directly - should fail)
    // Uncommenting the following function should cause compilation error
    /*
    public fun try_access_private(): u64 {
        internal_private_function() // Error: cannot call private function
    }
    */

    // Helper function to be called internally in modules/scripts
    public fun dummy(): u64 {
        0
    }
}


//# run 0xCAFE::InteractionTest::entry_point --signers 0xBADA --args true 10 20 15 255 255


//# run 0xCAFE::InteractionTest::try_access_private --signers 0xBADA


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// d6f1856345e9323c4256bcaff78ef69a: Test that left and right shift operations on u8 constants correctly handle shifts greater than or equal to the bit width and produce valid constant values.
