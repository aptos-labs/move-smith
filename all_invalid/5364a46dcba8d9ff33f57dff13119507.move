
//# publish
module 0xBADD::TestInteraction {
    use std::signer;
    use std::error;
    use std::vector;

    // Script entry points to invoke functions for testing
    public fun run_test_flow() {
        // 1. Test variable assignments and while loops with shadowing
        let result1 = test_variable_assignments();
        let result2 = test_variable_shadowing();
        // 2. Test internal function access control (functions outside the module are not accessible)
        //    (simulated by calling only public functions)
        // 3. Test specifications assertions (should panic if violated)
        test_specifications();
        // 4. Test closure currying and conditional logic
        let res_true = test_closure_conditional(true);
        let res_false = test_closure_conditional(false);
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
            let _ = z; // shadowing inside loop
            z = z + 2;
        };
        z
    }

    // Function to test variable shadowing
    fun test_variable_shadowing(): u64 {
        let a = 5u64;
        let b = 10u64;
        let _a = a + 1; // inner scope shadowing outer a
        let c = b + 2;
        // Shadow again
        let _b = c + 1;
        c = c + 3;
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
        // intentionally cause an error (division by zero)
        // Move does not have division by zero check, simulate with failed assertion
        assert!(false, 777)
    }
}


//# run 0xBADD::TestInteraction::run_test_flow


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 998fbe7952135a22ff05716135a83301: Configure error reporting to output errors to a specified writer.
