
//# publish
module 0xCAFE::LivenessShadowingDebugTest {
    use std::debug;
    use std::signer;

    // Struct to hold debug info about variable live status
    struct LiveStatus has copy, drop {
        var_name: vector<u8>,
        is_live: bool,
    }

    // A helper function to simulate liveness checking
    // We "fake" liveness by checking predefined code points manually
    // In real compiler, this would be intrinsic query. Here we simulate logic.
    public fun check_liveness_point1(x: u8): vector<LiveStatus> {
        // At this point, only original x is live
        let var_x = LiveStatus { var_name: b"x", is_live: true };
        let var_shadowed_x = LiveStatus { var_name: b"x_shadowed", is_live: false };
        vector[ var_x, var_shadowed_x ]
    }

    public fun check_liveness_point2(x: u8): vector<LiveStatus> {
        // After shadowing x, original x dead, shadowed live
        let var_x = LiveStatus { var_name: b"x", is_live: false };
        let var_shadowed_x = LiveStatus { var_name: b"x_shadowed", is_live: true };
        vector[ var_x, var_shadowed_x ]
    }

    // Function with shadowing and liveness checkpoints interleaved
    public fun shadow_and_check_liveness(x: u8): vector<LiveStatus> {
        // x is live here
        let live1 = check_liveness_point1(x);

        // Shadow x
        let x = x + 10;

        // Now new x is live, old x shadows and should be dead
        let live2 = check_liveness_point2(x);

        // Return both live status snapshots concatenated
        // flatten two vectors into one
        vector::append(&mut vector::copy(&live1), &live2)
    }

    // Function with multiple shadowing and checks
    public fun multiple_shadowings_and_liveness(x: u8): vector<LiveStatus> {
        let live_statuses = vector::empty<LiveStatus>();

        // First x live
        let live_statuses = vector::push_back(&mut vector::copy(&live_statuses), LiveStatus { var_name: b"x1_start", is_live: true });

        let x = x + 1;
        let live_statuses = vector::push_back(&mut vector::copy(&live_statuses), LiveStatus { var_name: b"x_shadow_1", is_live: true });

        // Shadow x again
        let x = x + 2;
        let live_statuses = vector::push_back(&mut vector::copy(&live_statuses), LiveStatus { var_name: b"x_shadow_2", is_live: true });

        // Dead statuses for previous shadows
        let dead = LiveStatus { var_name: b"x_shadow_1", is_live: false };
        let live_statuses = vector::push_back(&mut vector::copy(&live_statuses), dead);

        live_statuses
    }

    // Function that toggles debug output based on environment variable
    public fun debug_enabled_run() {
        if (debug::is_compiler_debug_enabled()) {
            debug::print(b"Debugging is ENABLED\n");
            let statuses = shadow_and_check_liveness(5u8);
            for (status in &statuses) {
                debug::print(&status.var_name);
                if (status.is_live) {
                    debug::print(b": live\n");
                } else {
                    debug::print(b": dead\n");
                };
            };
        } else {
            debug::print(b"Debugging is DISABLED\n");
        };
    }

    // Runner function without args to trigger tests
    public fun run_all() {
        let _ = shadow_and_check_liveness(3u8);
        let _ = multiple_shadowings_and_liveness(4u8);
        debug_enabled_run();
    }
}


//# run 0xCAFE::LivenessShadowingDebugTest::run_all


// Featurres:
// 4a6bff41920ddd55c5486d32e639f7aa: View which local variables are live at a specific point in a function during compilation.
// bee5aaf4ba9d59bba6d9bf8966e5f0ff: Test that shadowed variable names within the same function have the correct scoping and value assignment behavior.
// 76db04c52bd26e2e7420d642e79c0e64: Use environment variables to enable compiler debugging features
