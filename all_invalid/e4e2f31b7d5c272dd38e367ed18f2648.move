//# publish
module MyTestModule {

    // Use internal to restrict access
    internal struct Counter {
        count: u64,
    }

    // Entry function to test variable assignment, shadowing, and loop handling
    public script {
        // Variables outside the loop
        let x: u32 = 10;
        let y: bool = true;

        // Shadowed variable inside loop
        let i: u64 = 0;

        // Loop to test variable handling
        while (i < 5) {
            // Shadowed variable 'x' inside loop
            let x: u32 = x + 1;          // Shadow outer x
            let y: bool = !y;           // Shadow outer y

            // Use the variables inside the loop
            // For demonstration, you could log or perform assertions
            // but in Move scripts, we typically just modify state or produce results.

            // Example: updating module state, omitted here
            i = i + 1;                 // Increment loop counter
        }

        // After loop, ensure outer variables are unchanged
        // In a real test, you might assert their values
        assert_and_revert!(x == 10);   // Should remain unchanged
        assert_and_revert!(y == true); // Should remain unchanged
    }

    // Utility function for assertions (placeholder)
    fun assert_and_revert(condition: bool) {
        if (!condition) {
            abort 1;
        }
    }

    // Example primitive variables for completeness
    // (not necessarily used unless needed)
    public fun demonstrate_primitives() {
        let my_bool: bool = true;
        let my_u8: u8 = 255;
        let my_u16: u16 = 65535;
        let my_u32: u32 = 4294967295;
        let my_u64: u64 = 18446744073709551615;
        let my_u128: u128 = 340282366920938463463374607431768211455;
        let my_u256: u256 = 0; // As placeholder

        // Use primitives as needed
        // For now, just placeholders
    }
}
