
//# publish
module 0xBADD::FeatureInteractionTest {
    // Internal function with local variable shadowing and scope
    fun internal_shadowing_example() {
        let var: u8 = 10;
        // Shadowing the outer var within local scope
        {
            let var: u8 = 20;
        };
        // 'var' here should still be 10
        assert!(var == 10, 999);
    }

    // Function with explicit abort with annotated offset
    public fun abort_at_offset() {
        abort 42; // ESCAPE: offset 0x0
    }

    // Internal function to check variable bindings
    fun check_bindings(x: u8, y: u8): (u8, u8) {
        let (x, y) = (x + 1, y + 2);
        (x, y)
    }

    // Function to test while loop with local variable assignment
    fun while_loop_test(start: u8): u8 {
        let i = start;
        while (i < 5) {
            let _ = i; // Shadow iteratively
            i = i + 1;
        };
        i
    }

    // Internal function with nested blocks and variable bindings
    fun nested_blocks_test() {
        let a = 1u8;
        {
            let a = 2u8;
            assert!(a == 2, 998);
        };
        assert!(a == 1, 997);
    }

    // Function with specification: test global vs local variables
    public fun spec_variables() {
        let global_var: u8 = 7;
        let local_var = 3;
        // Local variable shadows the global one (simulate global in context)
        // No actual global, but check variable scope
        assert!(local_var == 3, 996);
        assert!(global_var == 7, 995);
    }

    // Function that uses an external function with internal visibility
    fun internal_private_func() {
        // Call another internal function
        helper_function();
    }

    fun helper_function() {
        // Simple asserts
        assert!(true, 994);
    }
}

// Script to execute the above functions to test variable shadowing, abort, and loops

//# run 0xBADD::FeatureInteractionTest::internal_shadowing_example


//# run 0xBADD::FeatureInteractionTest::check_bindings --args 8u8 15u8


//# run 0xBADD::FeatureInteractionTest::while_loop_test --args 2u8


//# run 0xBADD::FeatureInteractionTest::nested_blocks_test


//# run 0xBADD::FeatureInteractionTest::spec_variables


//# run 0xBADD::FeatureInteractionTest::abort_at_offset


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
// 65710f2313c5bd3e3af9efd82f251953: Write functions that can have explicit abort states annotated at specific code offsets
