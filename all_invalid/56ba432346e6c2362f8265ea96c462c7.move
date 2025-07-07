
//# publish
module 0xBADD::TestInteraction {
    use std::signer;
    use std::error;
    use std::vector;

    // Script entry points to invoke functions for testing
    public fun run_test_flow() {
        // 1. Test variable assignments and while loops with shadowing
        let _result1 = test_variable_assignments();
        let _result2 = test_variable_shadowing();
        // 2. Test internal function access control (functions outside the module are not accessible)
        //    (simulated by calling only public functions)
        // 3. Test specifications assertions (should panic if violated)
        test_specifications();
        // 4. Test closure currying and conditional logic
        let _res_true = test_closure_conditional(true);
        let _res_false = test_closure_conditional(false);
        // 5. Test error reporting in an induced error
        test_error_reporting();
        ()
    }

    // Function to test variable assignments inside while loop, outside
    fun test_variable_assignments(): u64 {
        let x = 0u64;
        let y = 10u64;
        let z = x;
        while (z < y) {
            // Shadowing inside loop (not necessary, but if intended, define a new variable)
            // Here, z is mutable; shadowing is not possible with the same name in Move
            // So, we just modify z
            z = z + 2;
        };
        z
    }

    // Function to test variable shadowing
    fun test_variable_shadowing(): u64 {
        let a = 5u64;
        let b = 10u64;
        // Shadowing inner scope variables is not directly supported in Move.
        // To simulate shadowing, you can assign new variable names.
        let a2 = a + 1; // shadowing outer a, but as Move does not have inner scope, we use different variable name
        let c = b + 2;
        let _b = c + 1; // shadowing b
        let c = c + 3; // rebind c (shadowing same name with new value)
        c
    }

    // Function enforcing specifications that should panic
    fun test_specifications() {
        assert!(1 + 1 == 2, 999)
    }

    // Function to test conditional closure currying
    public fun test_closure_conditional(condition: bool): u8 {
        let lambda: |u8| u8 = |a: u8| {
            if (condition) {
                a + 1
            } else {
                a - 1
            }
        };
        lambda(10)
    }

    // Function to induce error and test reporting
    fun test_error_reporting() {
        // intentionally cause an error (division by zero); simulate with failed assertion
        // We cannot cause runtime division by zero directly, but assertion with false can simulate an error
        assert!(false, 777);
    }
}


//# run 0xBADD::TestInteraction::run_test_flow
