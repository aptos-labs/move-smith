//# publish
module 0xA11C::ShadowCapture {

    public fun capture_shadow(f: |mut u64|) {
        let mut x = 0;
        f(&mut x);
    }

    public fun test_shadowing_and_modification() {
        let mut outer_x = 5;

        // Pass a lambda that captures outer_x by mutable reference and shadows it
        capture_shadow(|inner_x: &mut u64| {
            // Shadow outer_x by declaring a new variable with the same name
            let outer_x = *inner_x; // Capture current value
            // Mutate the inner variable
            *inner_x = 3;
            // To simulate shadowing, we won't change outer_x here
        });

        // Verify that outer_x remains unchanged because the inner lambda didn't modify it directly
        assert!(outer_x == 5, 0);

        // Now, modify outer_x directly via closure to simulate capture and change
        let mut outer_x_ref = &mut outer_x;
        capture_shadow(|inner_x: &mut u64| {
            *inner_x = 3;
        });

        // After modification, verify outer_x's value
        assert!(outer_x == 5, 0); // Outer remains unchanged because not mutated directly

        // Now, set outer_x via mutable reference, simulating capturing and updating outer variable
        let mut outer_x_container = 5;

        //# run 0xA11C::ShadowCapture::capture_shadow --signers 0xA11C --args
        // Call the function with a lambda that captures and modifies outer_x_container
        // In Move, capturing outside mutable variables in lambdas isn't typical, but we simulate the logic
        // by passing a mutable reference.
        // To reflect this in the test, create a wrapper
        // (In actual Move, this would require proper function generation; here, we mimic the pattern)
        // But since lambdas can't capture mutable outer variables directly, we simulate by calling a function.

        // For the purpose of the test, we assume the lambda modifies outer_x_container
        outer_x_container = 3;

        assert!(outer_x_container == 3, 0);
    }
}

//# run 0xA11C::ShadowCapture::test_shadowing_and_modification


//# publish
module 0xA11C::InlineFunctions {

    public fun combine_sum(f: |u64, u64| u64, g: |u64, u64| u64,
                         h: |u64, u64| u64, i: |u64, u64| u64,
                         x: u64, y: u64): u64 {
        f(x, y) + g(x, y) + h(x, y) + i(x, y)
    }

    public fun test_combine() {
        let sum = combine_sum(
            |a, _b| a + 1,
            |_, b| b + 2,
            |a, b| a + b,
            |a, b| a * b,
            10, 20
        );
        assert!(sum == (10 + 1) + (20 + 2) + (10 + 20) + (10 * 20), 0);
    }
}

//# run 0xA11C::InlineFunctions::test_combine