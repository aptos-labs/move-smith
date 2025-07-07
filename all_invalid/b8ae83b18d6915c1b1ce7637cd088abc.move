// Assuming the original code was intended to test variable shadowing inside and outside a while loop,
// here's a fixed example of a Move test script that demonstrates correct variable handling without compilation errors.

//# run
script {
    use std::debug;

    fun main() {
        let outer_var: u64 = 0;

        // Variable outside the loop
        outer_var = 10;

        // Shadowing variable inside the loop
        let inner_var: u64 = 0;

        while (outer_var > 0) {
            // Shadow inner_var inside the loop
            let inner_var: u64 = outer_var;
            // Increment inner_var
            inner_var = inner_var + 1;

            // Print inner_var to verify its value
            debug::print(&inner_var);
            // Decrement outer_var
            outer_var = outer_var - 1;
        }

        // After loop, outer_var should be decremented to 0
        debug::print(&outer_var);
        // The inner_var outside the loop remains unaffected
        // Let's demonstrate that by defining a variable with a different name if needed.
    }
}
