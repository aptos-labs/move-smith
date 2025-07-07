//# publish
module 0xA11E::ShadowTest {
    public inline fun inner_function<F: |u8|>(value: &mut u8, f: F) {
        let _x = 5;
        f(_x);
    }

    public fun test_shadow_override() {
        let _x = 2;
        inner_function(|shadow_var: u8| {
            // Attempt to assign to outer _x via the lambda parameter shadowing
            // First, declare a local variable to shadow outer _x
            // then assign to it to verify shadowing.
            // The outer _x should NOT be modified by this lambda.
            let _x = shadow_var;
            // The inner _x within lambda is shadowed; not the outer one.
        });
        // The outer _x should remain unchanged if inner_function operates only within its scope
        // but if inner_function can assign to outer _x via lambda, outer _x could change.
        // For this test, we want to verify if the lambda's _x shadows outer _x.
        assert!(_x == 2, 0);
    }

    // Runner to invoke test_shadow_override
    public fun run_tests() {
        test_shadow_override();
    }
}

//# run 0xA11E::ShadowTest::run_tests

//# publish
module 0xA11E::ResourceLoopTest {
    struct Counter has drop {
        count: u64
    }

    public fun new_counter(): Counter {
        Counter { count: 0 }
    }

    public fun get_count(c: &Counter): u64 {
        c.count
    }

    public fun increment(c: &mut Counter): u64 {
        c.count = c.count + 2;
        c.count
    }

    public fun run_loop() {
        let counter = new_counter();
        let mut i = 0;
        // Loop to increment the counter 5 times
        while (i < 5) {
            let new_val = increment(&mut counter);
            // Verify that each increment adds 2
            // For testing, could include assertions, but per instructions, focus on core logic
            i = i + 1
        }
        // After the loop, counter.count should be 10
        assert!(get_count(&counter) == 10, 70004);
    }
}

//# run 0xA11E::ResourceLoopTest::run_loop