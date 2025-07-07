
//# publish
module 0xCAFE::VariableScopeTest {
    use std::signer;
    use std::debug;

    // Struct to test struct creation and field access
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Internal functions should be declared as 'public fun' or 'fun' within the module.
    // Move does not support 'internal' visibility specifier; all functions are either public or private.
    // Since the function is meant to be internal (not public), declare as 'fun' (private by default).

    // Function to demonstrate variable creation, modification, and scope
    fun assign_and_modify_variables_inside_loop(x: u64): (u64, u64, u64) {
        let outer_var = x;
        let y = 0;
        let z = 0;

        while (outer_var < 5) {
            let inner_x = outer_var + 10; // new variable in loop scope
            y = inner_x; // update y
            z = z + inner_x; // accumulate in z
            let _ = debug::print(&b"Inside loop\n"[..]);
            outer_var = outer_var + 1;
        };
        (outer_var, y, z)
    }

    // Function to create and return a Point struct
    public fun create_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    // Entry point script to call above functions
    public fun execute_test() {
        // Call internal function to verify variable assignment and scope
        let (final_var, y_value, sum) = assign_and_modify_variables_inside_loop(0);
        // Create a Point struct
        let p = create_point(3, 7);
        let _ = debug::print(&b"Test execute completed\n"[..]);
    }
}



//# run 0xCAFE::VariableScopeTest::execute_test
