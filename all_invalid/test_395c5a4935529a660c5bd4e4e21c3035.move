//# publish
module 0xabc::transactional_tests {
    fun inc(x: &mut u64): u64 {
        *x = *x + 1;
        *x
    }

    //# run 0xabc::transactional_tests::sequential_nested_calls
    public fun sequential_nested_calls(): u64 {
        let total = 0;
        let mut counter = 0;

        // Perform multiple sequential increments
        let val1 = inc(&mut counter);
        let val2 = inc(&mut counter);
        let val3 = inc(&mut counter);

        // Perform nested block with more increments
        let nested_sum = {
            let mut inner_counter = counter;
            inc(&mut inner_counter) + inc(&mut inner_counter)
        };

        // Update total
        total + val1 + val2 + val3 + nested_sum
    }

    //# run 0xabc::transactional_tests::nested_calls_multiple_levels
    public fun nested_calls_multiple_levels(): u64 {
        let total = 0;
        let mut outer_counter = 10;

        // First level nested call
        let level1_sum = {
            // Shadow outer_counter
            let mut outer_counter = outer_counter;
            // Increment twice
            inc(&mut outer_counter);
            inc(&mut outer_counter);
            // Nested inside
            let mut inner_counter = outer_counter;
            inc(&mut inner_counter) + inc(&mut inner_counter)
        };

        // Second level nested call
        let level2_sum = {
            let mut inner_outer_counter = outer_counter;
            // Increment three times
            inc(&mut inner_outer_counter);
            inc(&mut inner_outer_counter);
            inc(&mut inner_outer_counter);
            // Further nested
            let mut inner_inner_counter = inner_outer_counter;
            inc(&mut inner_inner_counter) + inc(&mut inner_inner_counter)
        };

        // Sum totals
        total + level1_sum + level2_sum
    }

    //# run 0xabc::transactional_tests::shadow_variable_capture
    public inline fun shadow_capture(f:|u64|) {
        let _x = 5;
        f(_x);
    }

    public fun test_variable_shadowing() {
        let _x = 2;
        shadow_capture(|y| {
            // Attempt to modify captured _x
            // In Move, capturing variables into lambdas like this is typically by reference,
            // but since this is a simplified test, assume _x can be shadowed or captured.
            // For the purpose of simulation, assign to a new variable.
            let _x = y; // Shadowing _x inside lambda
            // There is no direct way to mutate outer _x here seamlessly, but we can mimic shadowing
        });
        // Ensure outer _x remains unchanged
        assert!(_x == 2, 0);
    }
}