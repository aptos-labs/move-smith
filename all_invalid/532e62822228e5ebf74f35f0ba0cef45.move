// File: tests/integration/test_local_vars_attributes.move

// This test script validates:
// 1. That local variables and arithmetic expressions work in a Move function.
// 2. That check_exp correctly checks expression purity (via the provided specification environment).
// 3. That individual 'use' statements can carry attributes.

script {
    // -- Section 1: Using attributes on individual `use` declarations --
    #[doc = "Use the Aptos Stdlib"]
    use std::signer;
    #[doc = "Use a dummy module for spec checking"]
    use std::vector;

    // Dummy spec environment for `check_exp` simulation:
    // Assuming the test framework exposes a native function check_exp(env: &SpecEnv, exp: &Exp) -> bool
    // Here we simulate it instead by a native function call.

    // Import spec environment & expressions (pseudo module, for illustration)
    use spec_env::{SpecEnv, check_exp, Exp};

    /// A test function that:
    /// - declares local integer variables
    /// - performs arithmetic (addition, multiplication)
    /// - verifies an expression's purity with check_exp
    fun test_local_variables_and_purity_check(env: &SpecEnv) acquires SpecEnv {
        // Local variables and arithmetic expressions
        let a: u64 = 10;
        let b: u64 = 5;
        let c: u64 = a + b;      // addition
        let d: u64 = c * b;      // multiplication

        // Just to use the variables and avoid unused variable warnings:
        let _ = d;

        // Construct expressions manually for purity check (hypothetical)
        let exp_add = Exp::BinOp(Exp::Var("a"), Exp::Var("b"), 0); // 0 = plus?
        let exp_mul = Exp::BinOp(exp_add, Exp::Var("b"), 1); // 1 = multiply?

        // Check purity of an expression using the environment's rules
        let result_add_pure = check_exp(env, &exp_add);
        let result_mul_pure = check_exp(env, &exp_mul);

        assert!(result_add_pure, 1001);
        assert!(result_mul_pure, 1002);
    }

    #[test_only]
    fun run_test() {
        let env = SpecEnv::new();
        test_local_variables_and_purity_check(&env);
    }
}

// Featurres:
// 7f5f485a46e2de7bb31ad797f6d00c23: Test that local variable declarations and arithmetic expressions execute without errors in a Move function.
// 097d2858766da6b23e17620ce967a697: Use the check_exp function to verify the purity of an expression according to the specification rules in the environment.
// a618575568cc48edf7aa4150c6567ef8: Attach attributes to individual 'use' declarations inside your script.
