//# publish
module 0x1::TestVariableShadowing {
    // Using 'internal' to restrict visibility within the module
    internal fun increment_counter(counter: &mut u64) {
        *counter = *counter + 1;
    }

    // Entry point for the test
    public script {
        let outer_var: u64 = 0;

        // Loop to test variable shadowing
        let i: u64 = 0;
        while (i < 5) {
            // Shadowing 'outer_var' inside the loop
            let outer_var = outer_var; // shadowing outer variable
            // Modify inner 'outer_var'
            let inner_counter = 0;

            // Inside loop, increment inner_counter
            while (inner_counter < 3) {
                internal::increment_counter(&mut inner_counter);
            }

            // After inner loop, update outer_var
            outer_var = outer_var + 10;

            // Increment loop index
            i = i + 1;
        }

        // After loop, verify that outer_var is updated correctly
        // For testing, we can emit an event or assert, but here we'll just preserve it.
        // In real tests, you might call functions or emit events to confirm values.
        move_to(signer, OuterVarHolder { value: outer_var });
    }

    // A holder resource to verify value in tests
    struct OuterVarHolder {
        value: u64,
    }

    // Function to get the outer_var value (for testing)
    public fun get_outer_var(holder: &OuterVarHolder): u64 {
        holder.value
    }
}
