//# publish
module 0xA1B2::interaction_tests {

    // Test inline functions and function calls with different parameter types
    inline fun compute_sum(a: u64, b: u64): u64 {
        a + b
    }

    inline fun pass_tuple(t: (u8, u16), f: |u8|u16): u16 {
        f(t.0)
    }

    public fun test_invoke_functions(): u64 {
        let val1 = compute_sum(10, 20);
        let tuple_param = (5u8, 1000u16);
        let val2 = pass_tuple(tuple_param, |x| x as u16 + 10);
        val1 + val2 as u64
    }

    //# run 0xA1B2::interaction_tests::test_invoke_functions

    // Test variable assignment, including reassignment with different inline functions
    public fun test_variable_assignments(): u64 {
        let mut x = 0u64;
        let inline_fn1 = |z: u64| z + 5;
        x = inline_fn1(10);
        assert!(x == 15, 42);
        let inline_fn2 = |w: u64| w * 2;
        x = inline_fn2(x);
        x
    }

    //# run 0xA1B2::interaction_tests::test_variable_assignments

    // Test handling of nested tuples and inline functions that operate on them
    inline fun process_nested(t: ((u8, u16), u32), f: |u8, u16|u32): u32 {
        let ((a, b), c) = t;
        f(a, b) + c
    }

    public fun test_nested_tuples(): u32 {
        let nested = ((3u8, 500u16), 100u32);
        process_nested(nested, |x, y| y as u32 + x as u32)
    }

    //# run 0xA1B2::interaction_tests::test_nested_tuples

    // Test the correctness of closures with captured variables
    public fun test_closure_capture(): u64 {
        let factor = 3u64;
        let closure = |x: u64| x * factor;
        closure(7)
    }

    //# run 0xA1B2::interaction_tests::test_closure_capture

    // Test that a function returning a function (closure) works correctly
    public fun produce_multiplier(m: u64): |u64|u64 {
        |x: u64| x * m
    }

    public fun test_function_returning_closure(): u64 {
        let times_two = produce_multiplier(2);
        times_two(15)
    }

    //# run 0xA1B2::interaction_tests::test_function_returning_closure

    // Test combined inline and normal functions with parameters and tuples
    inline fun sum_tuple_elements(t: (u8, u8)): u16 {
        t.0 as u16 + t.1 as u16
    }

    public fun test_inline_with_params(): u64 {
        let t = (7u8, 8u8);
        let summed = sum_tuple_elements(t);
        summed as u64 * 2
    }

    //# run 0xA1B2::interaction_tests::test_inline_with_params
}