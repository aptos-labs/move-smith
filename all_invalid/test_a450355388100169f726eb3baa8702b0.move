//# publish
module 0xAABB::InteractionTest {

    public inline fun apply_closure(f:|u64|, val: u64): u64 {
        f(val)
    }

    public fun test_variable_capture() {
        let x = 5;
        let mut y = 0;

        // Define a closure that captures 'x' and modifies 'y'
        apply_closure(|v: u64| {
            // Capture 'x' and set 'y' to x + v
            // Shadowing 'x' intentionally (though in Move, this is different from other languages)
            y = x + v
        }, 2);
        // Expect y to be 7 (5 + 2)
        assert!(y == 7, y);
    }

    public fun test_shadowing_in_function() {
        let x = 10;
        let mut result = 0;

        // Inner function shadows outer 'x'
        fun inner_function() {
            let x = 20; // Shadow outer 'x'
            result = x; // Should assign 20
        }
        inner_function();
        // Verify shadowing
        assert!(result == 20, result);
        // Outer 'x' remains unchanged
        assert!(x == 10, x);
    }

    public fun test_nested_closures_modification() {
        let outer = 0;
        let mut final_value = 0;

        // First closure captures 'outer' mutable
        apply_closure(|v: u64| {
            // Shadow 'outer'
            let mut outer = v;
            // Nested closure modifies 'outer'
            // Since Move closures are copy by default, simulate capturing by passing to another apply_closure
            fun nested_closure() {
                outer = outer + 5;
            }
            nested_closure();
            final_value = outer;
        }, 3);
        // After applying, 'final_value' should be '3 + 5 = 8'
        assert!(final_value == 8, final_value);
    }
}

//# run 0xAABB::InteractionTest::test_variable_capture --signers 0x1
//# run 0xAABB::InteractionTest::test_shadowing_in_function --signers 0x1
//# run 0xAABB::InteractionTest::test_nested_closures_modification --signers 0x1