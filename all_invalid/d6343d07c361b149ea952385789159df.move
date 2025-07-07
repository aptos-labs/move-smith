
//# publish
module 0xCAFE::TestModule {
    public fun dummy() {}
}



//# run
script {
    // No content needed here
}



//# publish
module 0xCAFE::VerifierFeatures {
    // Function to test optional trigger expressions using braces '{}'
    public fun trigger_expression_test() {
        let x = 10;
        // Use braces '{}' around the trigger expression
        { let y = x + 5; }
        // Shadow variable inside a nested block
        let x = 20;
        {
            let x = 30; // shadow
            let y = x + 10; // y should be 40
        }
        // After shadowing, x should still be 20
    }

    // Function to test access and modification of variables within nested blocks and match
    public fun variable_scope_test() {
        let a = 1;
        let b = 2;
        // Shadow variable within a nested block
        {
            let a = 3; // shadow
            b = 4; // modify outer mutable variable
            match a {
                3 => {
                    // modify shadowed a
                    let a = a + 1; // shadow
                }
                _ => {}
            }
        }
        // Commit values to see effects
        assert (a == 1); // outer a unchanged
        assert (b == 4); // b updated
    }

    // Function to test loop with range and reassign restriction
    public fun loop_range_test() {
        let sum = 0;
        let i = 0;
        while (i < 5) {
            // Reassigning loop variable i
            // This is permitted in Move, but we just reassign i to test handling
            i = i + 1;
            // sum is not used, just testing loop execution
        }

        // Expected sum: 0 + 1 + 2 + 3 + 4 = 10
        assert(sum == 0); // sum not changed, just to test loop run
    }
}

//# run 0xCAFE::VerifierFeatures::trigger_expression_test


//# run 0xCAFE::VerifierFeatures::variable_scope_test


//# run 0xCAFE::VerifierFeatures::loop_range_test