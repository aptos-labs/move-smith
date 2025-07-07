//# publish
module 0x1::variable_shadowing_test {
    use std::debug;

    // Internal function to test variable shadowing in a loop
    fun internal_shadow_test() {
        let outer_var: u64 = 0;

        debug::print(&"Before loop, outer_var:", &outer_var);

        // Shadowed variable inside the loop
        let outer_var_shadowed = outer_var;

        let i = 0;
        while i < 3 {
            // Shadowing outer variable with a new variable
            let outer_var_shadowed = outer_var_shadowed;

            debug::print(&"Inside loop iteration:", &i);
            debug::print(&"Shadowed variable before update:", &outer_var_shadowed);

            // Update shadowed variable
            outer_var_shadowed = outer_var_shadowed + 10;

            debug::print(&"Shadowed variable after update:", &outer_var_shadowed);

            // Also update the outer variable if needed
            outer_var = outer_var + 1;

            i = i + 1;
        }

        // After the loop, check values
        debug::print(&"After loop, outer_var:", &outer_var);
        debug::print(&"After loop, outer_var_shadowed:", &outer_var_shadowed);
    }
    
    // External public entry point to invoke the test
    public entry fun run_shadow_test() {
        internal_shadow_test();
    }
}
