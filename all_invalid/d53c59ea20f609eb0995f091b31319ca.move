
//# publish
module 0xCAFE::VariableScopeTest {
    use std::signer;
    use std::debug;

    // Struct to test struct creation and field access
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Internal function to demonstrate variable creation, modification, and scope
    internal fun assign_and_modify_variables_inside_loop(x: u64): (u64, u64, u64) {
        let outer_var = x;
        let y = 0;
        let z = 0;

        while (outer_var < 5) {
            let inner_x = outer_var + 10; // shadowed or new variable in inner scope
            y = inner_x; // update y in outer scope
            z = z + inner_x; // accumulate in z
            // simulate some internal state changes
            let _ = debug::print(&b"Inside loop\n"[..]);
            // increment outer_var to eventually break loop
            outer_var = outer_var + 1;
        };
        (outer_var, y, z)
    }

    // Function to create and return a Point struct
    public fun create_point(x: u64, y: u64): Point {
        Point {x, y}
    }

    // Entry point script to call above internal and create functions
    public fun execute_test() {
        // Call internal function to verify variable assignment and scope
        let (final_var, y_value, sum) = assign_and_modify_variables_inside_loop(0);
        // Create a Point struct
        let p = create_point(3, 7);
        // No assertions, just execution
        let _ = debug::print(&b"Test execute completed\n"[..]);
    }
}


//# run 0xCAFE::VariableScopeTest::execute_test


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 227ad258a66ad82ed33365ca2fc3d83a: Define structs with named fields in Move modules
