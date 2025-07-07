//# publish
module 0x42::ShadowTest {

    public inline fun inner_assign(f:|u64|) {
        let _shadow = 5;
        f(_shadow);
    }

    public fun test_inner_shadow() {
        let _outer = 0;
        inner_assign(|value: u64| {
            _outer = value; // Expect `_outer` to be assigned 5 through the lambda.
        });
        // No assertion; just structure to observe behavior.
        // In real test, could assert!(_outer == 5, 0)
    }

    public fun test_shadow_toplevel() {
        let _x = 10;
        // Shadowing outer variable by defining a variable with the same name inside the lambda
        inner_assign(|_x: u64| {
            // Inside this lambda, _x is a new parameter shadows outer _x
        });
        // After the call, outer _x should remain unchanged
    }

    public fun test_multiple_assignments() {
        let _values = [1u64, 2u64, 3u64];
        let mut index = 0;
        inner_assign(|val: u64| {
            // Assign the current value from array to outer variable
            _values[index] = val;
            index = index + 1;
        });
        // No assertions, just to test that inner lambda can assign to external variables

    }
}

//# run 0x42::ShadowTest::test_inner_shadow
