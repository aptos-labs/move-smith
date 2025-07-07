
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Struct to hold test results
    struct ResultHolder has store {
        val: u64,
    }

    // A simple function that increments a number
    public fun simple_increment(x: u64): u64 {
        x + 1
    }

    // A generic function that multiplies two values
    // Removed usage of 'num::Zero' and 'num::One' abilities as they are not part of Move core.
    // Instead, restrict T to copy + std::ops::Mul<Output = T>
    public fun generic_multiply<T: copy + std::ops::Mul<Output = T>>(a: T, b: T): T {
        a * b
    }

    // A higher-order function that takes a function pointer and calls it
    public fun call_function(func: |u64| -> u64, val: u64): u64 {
        func(val)
    }

    // A wrapper to call the generic multiply with specific type parameter
    public fun call_generic_multiply_i64(a: i64, b: i64): i64 {
        generic_multiply<i64>(a, b)
    }

    // Function to test variable shadowing inside loops
    public fun shadowing_test(): (u64, u64, u64) {
        let outside_var = 0;
        let pre_loop_var = 0;
        // simulate variable outside loop
        outside_var = 100;

        let pre_loop_var2 = 0;

        while (true) {
            // Shadowed variable inside loop
            let outside_var = outside_var + 1;
            let pre_loop_var = pre_loop_var + 10;

            // Use the new shadowed outside_var
            if (outside_var > 102) {
                break;
            };
        };

        // After loop, check that outside_var is unchanged
        let after_loop_value = outside_var;
        // The shadowed outside_var within loop does not affect this
        // pre_loop_var was modified inside loop
        let final_pre_loop_var = pre_loop_var;

        (after_loop_value, final_pre_loop_var, outside_var)
    }

    // Function to test passing function as a first-class value
    public fun store_and_invoke_fn(): u64 {
        let f_ptr: |u64| -> u64 = simple_increment;
        // Store function in a variable and invoke
        let result = call_function(f_ptr, 41);
        result
    }

    // Function to test generic function pointer invocation
    public fun generic_invocation(): u64 {
        let f_ptr: |u64| -> u64 = simple_increment;
        let result = call_function(f_ptr, 10);
        result
    }

    // Function to test nested function calls and passing functions as arguments
    public fun nested_calls(): (u64, u64) {
        let res1 = simple_increment(5);
        let res2 = call_function(simple_increment, 20);
        (res1, res2)
    }

    // Function to test variable assignment and shadowing
    public fun variable_shadowing(): u64 {
        let val = 7;
        let val = val + 3; // shadowing previous
        val
    }

    // Entry point to test all features, called from script
    public fun run_all_tests(): bool {
        // Test variable shadowing inside loop
        let (outside_val, pre_loop, outer_shadow) = shadowing_test();
        assert!(outside_val == 100, 111);
        assert!(pre_loop == 10, 112);
        assert!(outer_shadow == 100, 113);

        // Test function as first class, stored and invoked
        let fn_result = store_and_invoke_fn();
        assert!(fn_result == 42, 114);

        // Test generic function invocation
        let gen_result = generic_invocation();
        assert!(gen_result == 11, 115);

        // Test nested function calls
        let (res1, res2) = nested_calls();
        assert!(res1 == 6, 116);
        assert!(res2 == 21, 117);

        // Test variable shadowing
        let shadowed_value = variable_shadowing();
        assert!(shadowed_value == 10, 118);

        // Test generic multiply with i64
        let mult_result = call_generic_multiply_i64(-3, 4);
        assert!(mult_result == -12, 119);

        true
    }
}



//# run 0xCAFE::TestModule::run_all_tests


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
