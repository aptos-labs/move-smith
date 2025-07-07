
//# publish
module 0xCAFE::LivenessShadowingDebugTest {
    use std::debug;
    use std::signer;
    use std::vector;

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
        vector::from_bytes(vector::concat(vec![var_x], vec![var_shadowed_x]))
    }

    public fun check_liveness_point2(x: u8): vector<LiveStatus> {
        // After shadowing x, original x dead, shadowed live
        let var_x = LiveStatus { var_name: b"x", is_live: false };
        let var_shadowed_x = LiveStatus { var_name: b"x_shadowed", is_live: true };
        vector::from_bytes(vector::concat(vec![var_x], vec![var_shadowed_x]))
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
        // fix: must allocate mutable vector, append live2 to it, then return
        let combined = vector::empty<LiveStatus>();
        vector::append(&mut combined, &live1);
        vector::append(&mut combined, &live2);
        combined
    }

    // Function with multiple shadowing and checks
    public fun multiple_shadowings_and_liveness(x: u8): vector<LiveStatus> {
        let live_statuses = vector::empty<LiveStatus>();

        // First x live
        vector::push_back(&mut live_statuses, LiveStatus { var_name: b"x1_start", is_live: true });

        let x = x + 1;
        vector::push_back(&mut live_statuses, LiveStatus { var_name: b"x_shadow_1", is_live: true });

        // Shadow x again
        let x = x + 2;
        vector::push_back(&mut live_statuses, LiveStatus { var_name: b"x_shadow_2", is_live: true });

        // Dead statuses for previous shadows
        let dead = LiveStatus { var_name: b"x_shadow_1", is_live: false };
        vector::push_back(&mut live_statuses, dead);

        live_statuses
    }

    // Function that toggles debug output based on environment variable
    public fun debug_enabled_run() {
        if (debug::is_compiler_debug_enabled()) {
            debug::print(b"Debugging is ENABLED\n");
            let statuses = shadow_and_check_liveness(5u8);
            let iter = vector::iter(&statuses);
            while (vector::has_next(&iter)) {
                let status = vector::next(&mut iter);
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
