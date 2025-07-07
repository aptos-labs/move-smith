//# publish
module 0x42::ShadowClosures {

    // This function demonstrates inline closure shadowing an outer variable and assigning to it.
    public fun shadow_outer_x(x: &mut u64) {
        // Assign a new value to the outer variable via closure
        let assign_value = |y: u64| {
            *x = y;
        };
        assign_value(100);
    }

    // This function demonstrates shadowing within a nested closure, nested inside another.
    public fun nested_shadowing(x: &mut u64) {
        let outer_val = 0;
        let inner_closure = |z: u64| {
            let inner_x = z; // Shadow outer variable
            *x = inner_x + 50; // Assign to outer via mutable reference
        };
        inner_closure(25);
    }

    // This function tests shadowing with local variable
    public fun test_local_shadowing(y: &mut u64) {
        let x = 10;
        let mutate_x = |z: u64| {
            // Shadow local variable x
            let x = z + 5;
            *y = x;
        };
        mutate_x(20);
    }

    // Entry function to run all shadowing tests
    public fun run_shadow_tests() {
        let x_mut = &mut 0u64;

        // Test direct shadowing
        shadow_outer_x(x_mut);
        assert!(*x_mut == 100, 1);

        // Test nested shadowing with closure
        nested_shadowing(x_mut);
        assert!(*x_mut == 75, 2);

        // Test local variable shadowing
        test_local_shadowing(x_mut);
        assert!(*x_mut == 25, 3);
    }
}

//# run 0x42::ShadowClosures::run_shadow_tests