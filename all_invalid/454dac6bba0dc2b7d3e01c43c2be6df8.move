//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Helper function to generate a vector of u8
    public fun create_vector(): vector<u8> {
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
        // Shadowing inside the loop
        let _x_inner = _x;
        let _y_inner = _y;
        while (_x_inner < _y_inner) {
            let _x = _x_inner + 1;
            let _y = _y_inner - 1;
            _x_inner = _x;
            _y_inner = _y;
        };
        (_x_inner, _y_inner)
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

    // Scripts are outside of functions, so they should be wrapped in a module or as scripts
    // In Move, scripts are top-level constructs, but in a module file, they are often separated.
    // For the purpose of this test, wrap each script in a 'script' block like this:

    // Script to run nested while loop variable scope and shadowing
    
//# script
    // (This is just a code snippet; in testing, replace with actual move script syntax)
    // move
    //     let initial_x = 0u8;
    //     let initial_y = 5u8;
    //     let outer_x = initial_x;
    //     let outer_y = initial_y;
    //     let shadow_value = 123u8;
    //
    //     while (outer_x < outer_y) {
    //         let _shadow_value = shadow_value + outer_x; // shadow inside loop
    //         outer_x = outer_x + 1;
    //         outer_y = outer_y - 1;
    //     };
    //
    //     // After loop, check variable values
    //     (outer_x, outer_y, shadow_value)
    // end

    // Script to test import resolution and module usage
    
//# script
    // (Replace as needed for test harness)
    // move
    //     let (first, last) = import_test();
    //     (first, last)
    // end

    // Script to test variable bindings and expression evaluation
    
//# script
    // move
    //     let result = binding_test();
    //     result
    // end

    // Script for combined testing
    
//# script
    // move
    //     let (s1, s2) = shadowing_test();
    //     let (import_first, import_last) = import_test();
    //     let bound_value = binding_test();

    //     (s1, s2, import_first, import_last, bound_value)
    // end
}
