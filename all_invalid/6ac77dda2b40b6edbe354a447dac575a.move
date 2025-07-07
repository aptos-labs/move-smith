
//# publish
module 0xCAFE vector_map_test {
    use std::vector;
    use std::signer;

    public entry fun run_map_over_constants(signer: &signer) {
        // Map over a vector of integers with a lambda
        let vec = vector::empty<u64>();
        vector::push_back(&mut vec, 1);
        vector::push_back(&mut vec, 2);
        vector::push_back(&mut vec, 3);

        let mapped_vec = vector::map(
            &vec,
            |x| { (*x) * 10 }
        );

        // The mapped vector should contain [10, 20, 30]
        // No assertion needed as per instructions
        // Return to end
    }

    // Test environment variable for color output (simulate with a function)
    public fun check_env_color_output(): bool {
        // Pseudo logic: For test purposes, we simulate environment behavior
        // In actual execution, the environment variable handling is external to Move
        // So this function is a placeholder
        true
    }

    // Bind multiple local variables via pattern and expressions
    public entry fun bind_multiple_vars() {
        // Multiple bindings using destructuring
        let (a, b) = (100, 200);
        let (x, y, z) = (a + 1, b + 2, a + b);
        // Variables a, b, x, y, z are now bound
        // No assertions
    }
}


//# run 0xCAFE::vector_map_test::run_map_over_constants --signers 0xCAFE

//# run 0xCAFE::vector_map_test::check_env_color_output

//# run 0xCAFE::vector_map_test::bind_multiple_vars

// Featurres:
// afcd1189a468c5f995c62e3ed503c280: Test that the std::vector::map function correctly maps over constant vectors with lambda functions in an entry function.
// cddd76dfccb7295a41a882307e9ffda9: Automatically choose color output for diagnostics if environment variable is unset or set to an unrecognized value.
// 1906cb0341c5279da7dce89c8d5e75fb: Bind the results of an expression to multiple local variables using lvalues in assignments and patterns
