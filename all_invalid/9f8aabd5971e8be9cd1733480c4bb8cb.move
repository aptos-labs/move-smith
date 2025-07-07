
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
        let a = x; // Changed to mutable
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
        let v = 0u8; // Changed to mutable
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
