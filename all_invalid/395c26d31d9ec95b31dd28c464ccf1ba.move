//# publish
module 0xCAFE::ApplyIncrement {
    public fun inc(r: &mut u64) {
        *r = *r + 1;
    }

    public fun test(): u64 {
        let mut x = 0;
        // Use apply keyword to apply the inc function repeatedly
        apply inc to &mut x;
        apply inc to &mut x;
        apply inc to &mut x;
        x
    }

    public fun test_loop(): u64 {
        let mut x = 0;
        // Loop 5 times, declare idx loop variable inside for
        for i in 0..5 {
            apply inc to &mut x;
        };
        x
    }

    public fun runner(): u64 {
        let a = test();
        let b = test_loop();
        a + b
    }
}
//# run 0xCAFE::ApplyIncrement::runner

// Featurres:
// 4e31573f00ae29fdd9af678a8155720e: Use the 'apply' keyword to specify a function expression to be applied to patterns in your Move code.
// 582bf6f000eedd329d50a0617d87039d: Test that the `inc` function correctly increments a mutable reference to a u64 and that the `test` function computes the expected combined value using multiple increments.
// 59e10dac00e363bde67a27b878077c5f: Declare and initialize a loop index variable within the 'for' loop.
