
//# publish
module 0xBADD::TestModule {
    // Lambda lifting test: convert lambdas into top-level functions
    public fun lambda_func1(a: u8, b: u8): (u8, u8) {
        let c = a + b;
        let d = a * b;
        (c, d)
    }
    public fun lambda_func2(e: u8, f: u8): (u8, u8) {
        let g = e - f;
        let h = e / (f + 1);
        (g, h)
    }

    // Function to test variable mutations in control flow
    public fun test_variable_mutation_in_branches(x: u8): u8 {
        let a = x;
        if (a % 2 == 0) {
            a = a + 10;
        } else {
            a = a + 20;
        };
        // After if-else, the variable a should reflect the last mutation
        a
    }

    // Function that exercises mutation persistence after control flow change
    public fun test_variable_persistence(): u8 {
        let v = 0u8;
        while (v < 5) {
            if (v == 2) {
                v = v + 4;
            } else {
                v = v + 1;
            };
        };
        v
    }

    // Main runner that calls the above functions
    public fun run_tests(): () {
        let _ = lambda_func1(2, 3);
        let _ = lambda_func2(10, 2);
        let res1 = test_variable_mutation_in_branches(5);
        assert!(res1 == 25, 999);
        let res2 = test_variable_persistence();
        assert!(res2 == 9, 998);
    }
}


//# run 0xBADD::TestModule::run_tests


// Featurres:
// 23bf4dac0b49aa979852f3fbacf7cb8b: Use lambda lifting to transform lambda expressions into top-level functions.
// 30f14d70505165800700e9ed1df8ca86: Declare Move modules using the 'module' keyword or as specification modules using the 'spec module' syntax.
// 055b2a98b3bc350f5ffc46c49565406a: Test that local variable mutations inside branches persist after function calls and control flow changes, ensuring correct variable values are used in later computations.
