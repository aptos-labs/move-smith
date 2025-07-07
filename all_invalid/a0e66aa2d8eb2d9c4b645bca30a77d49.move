
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Helper function to generate a vector of u8
    public fun create_vector() acquires std::vector {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);
        v
    }

    // Function to test nested variable shadowing in while loop
    public fun shadowing_test(): (u8, u8) {
        let x = 0u8;
        let y = 10u8;
        let _x = x; // inner shadow variable
        let _y = y; // inner shadow variable
        while (_x < _y) {
            let _x = _x + 1;
            let _y = _y - 1;
        };
        (_x, _y)
    }

    // Function to test importing and namespace resolution
    public fun import_test(): (u8, u8) {
        // Use the module to create a vector
        let v = create_vector();
        let first = *vector::borrow(&v, 0);
        let last = *vector::borrow(&v, vector::len(&v) - 1);
        (first, last)
    }

    // Function to test variable bindings with expression results
    public fun binding_test(): u64 {
        let a = 100u64;
        let b = a + 50;
        let c = b * 2;
        c
    }

    // Script to run nested while loop variable scope and shadowing
    
//# run
    script {
        let initial_x = 0u8;
        let initial_y = 5u8;
        let outer_x = initial_x;
        let outer_y = initial_y;
        let shadow_value = 123u8;

        while (outer_x < outer_y) {
            let _shadow_value = shadow_value + outer_x; // shadow inside loop
            outer_x = outer_x + 1;
            outer_y = outer_y - 1;
        };

        // After loop, check variable values
        (outer_x, outer_y, shadow_value)
    }

    // Script to test import resolution and module usage
    
//# run
    script {
        let (first, last) = import_test();
        // Bind resulting values to check correctness
        (first, last)
    }

    // Script to test variable bindings and expression evaluation
    
//# run
    script {
        let result = binding_test();
        result
    }

    // Script for combined testing: shadowing, import, and variable binding
    
//# run
    script {
        let (s1, s2) = shadowing_test();
        let (import_first, import_last) = import_test();
        let bound_value = binding_test();

        (s1, s2, import_first, import_last, bound_value)
    }
}


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 7674a9dca6177b17be0aef022cb10f2f: Import modules in Move files using the 'use' statement.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
