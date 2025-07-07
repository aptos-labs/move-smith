//# publish
module 0xBADD::FeatureInteractionTest {
    // Internal function with local variable shadowing and scope
    fun internal_shadowing_example() {
        let var: u8 = 10;
        // Shadowing the outer var within local scope
        {
            let var: u8 = 20;
            // No need for further actions here
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
        let (x_new, y_new) = (x + 1, y + 2);
        (x_new, y_new)
    }

    // Function to test while loop with local variable assignment
    fun while_loop_test(start: u8): u8 {
        let i = start;
        while (i < 5) {
            // Shadowing within loop is permitted, but to avoid warnings, use an underscore if unused
            // or just assign as needed
            // let _ = i; // Not necessary; just ensure loop logic
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
        // Local variable shadows the global one
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

//# run
script {
    // Call internal_shadowing_example
    0xBADD::FeatureInteractionTest::internal_shadowing_example();

    // Call check_bindings with arguments 8 and 15
    let (val_x, val_y) = 0xBADD::FeatureInteractionTest::check_bindings(8, 15);
    // Optionally, you can assert expected values
    assert!(val_x == 9, 993);
    assert!(val_y == 17, 992);

    // Call while_loop_test with argument 2
    let result = 0xBADD::FeatureInteractionTest::while_loop_test(2);
    assert!(result == 5, 991);

    // Call nested_blocks_test
    0xBADD::FeatureInteractionTest::nested_blocks_test();

    // Call spec_variables
    0xBADD::FeatureInteractionTest::spec_variables();

    // Call abort_at_offset
    // Warning: This will abort the transaction execution
    0xBADD::FeatureInteractionTest::abort_at_offset();
}
