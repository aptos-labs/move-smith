
//# publish
module 0xCAFE::IntegrationTest {
    use std::vector;
    use std::signer;

    // Entry point to invoke various feature tests
    public fun run_integration_tests(signer_addr: address) {
        // Call test script functions
        Self::test_variable_scope_and_shadowing(signer_addr);
        Self::test_function_as_first_class(signer_addr);
        Self::test_feature_combined_scenarios(signer_addr);
    }

    // Test variable scope and shadowing inside and outside loops
    public fun test_variable_scope_and_shadowing(s: address) {
        let outer_var = 10;
        let inner_var = 20;

        // Shadowing inside a while loop
        let shadow_var = 0;
        let _i: u64 = 0; // initialize mutable variable outside loop
        while (_i < 3) {
            let shadow_var = _i as u8; // shadowed variable
            assert!(shadow_var == _i as u8, 1000);
            _i = _i + 1;
        };
        // Check that original outer_var remains unchanged
        assert!(outer_var == 10, 1001);
        // Shadowed variable outside loop should not be accessible, so not referencing it here

        // Test that outer variable remains unchanged
        let outer_var_after = outer_var;
        assert!(outer_var_after == 10, 1002);
    }

    // Test functions as first-class citizens
    public fun test_function_as_first_class(s: address) {
        // Define a lambda function
        let lambda: |u8, u8| -> u8 = |a, b| {
            a + b
        };
        // Assign to a variable
        let func_var: |u8, u8| -> u8 = copy lambda;

        // Invoke the stored function
        let result: u8 = func_var(3, 4);
        assert!(result == 7, 2000);

        // Pass function as argument to another function that invokes it
        let invoked_result = Self::apply_function(lambda, 5, 6);
        assert!(invoked_result == 11, 2001);

        // Test generic function as first-class
        let g: forall T: copy + drop + store, U: copy + drop + store = |x: T, y: T| -> T {
            x
        };
        let val_u8: u8 = g(1u8, 2u8);
        assert!(val_u8 == 1, 2002);

        // Invoke generic function with concrete type
        let result_two: u16 = Self::generic_no_type_param::<u16>(42u16);
        assert!(result_two == 42, 2003);
    }

    // Helper function that takes a function and two u8s, calls the function
    public fun apply_function(f: |u8, u8| -> u8, a: u8, b: u8): u8 {
        f(a, b)
    }

    // Generic function without explicit type arguments
    public fun generic_no_type_param<T: copy + drop + store>(x: T): T {
        x
    }

    // Test combined complex scenarios
    public fun test_feature_combined_scenarios(s: address) {
        // Define a function that manipulates a variable inside a loop and relies on pre/post-conditions
        let counter = 0;
        let limit = 5;
        let process_fn: |u8| -> u8 = |x| {
            let sum = 0;
            let i = 0u8;
            while (i < x) {
                sum = sum + i;
                i = i + 1;
            };
            sum
        };
        // Invoke function with argument
        let result = process_fn(limit as u8);
        assert!(result == 10, 3000); // sum of 0..4

        // Use precondition: restrict x to be less than 10
        // Since Move doesn't support built-in preconditions, simulate check
        let check_x = |x: u8| {
            if (x >= 10) {
                abort 9999;
            };
        };
        check_x(limit as u8); // Should pass
        // check_x(20) would abort, but we don't call that here

        // Ensures correctness of multiple features
        // Call functions with first-class and shadowed variables
        let shadow_var = 123u8;
        let inner_func: |u8| -> u8 = |a| {
            let shadow_var = a; // shadow inner variable
            shadow_var + 1
        };
        let res = inner_func(shadow_var);
        assert!(res == 124, 3001);
    }
}


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
