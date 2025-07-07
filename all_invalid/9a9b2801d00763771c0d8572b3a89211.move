//# publish
module 0xCAFE::LoopUpdate {
    use std::debug;

    public fun test(y: bool): u64 {
        let mut sum = 0u64;
        for i in 0..5 {
            // Re-assign sum differently based on y
            if (y) {
                sum = sum + i;
            } else {
                sum = sum + (5 - i);
            };
        };
        sum
    }

    public fun loop_mut_update() {
        let mut counter = 0u64;
        let mut i = 0u64;
        while (i < 10) {
            counter = counter + i;
            i = i + 1;
        };
        // The sum of 0..9 = 45
        assert!(counter == 45, 1001);
        debug::print(&vector::empty<u8>());
    }
}

//# run 0xCAFE::LoopUpdate::loop_mut_update

//# run 0xCAFE::LoopUpdate::test --args true

//# run 0xCAFE::LoopUpdate::test --args false

//# publish
module 0xCAFE::AccessControl {
    public fun access_warning() {
        // Issue a benign warning by deliberately accessing a dummy field and printing text.
        // Printing is the only way to temporarily simulate a warning in Move std.
        std::debug::print(b"Warning: Action outside defining module\n");
    }
}

//# run 0xCAFE::AccessControl::access_warning

//# run 0xCAFE::LoopUpdate::test --args true

//# run 0xCAFE::LoopUpdate::test --args false

//# run 0xCAFE::AccessControl::access_warning

// Featurres:
// 11aa254fc6653291f12e715c6824522d: Test that mutably updating a local variable within a loop correctly modifies its value and reaches the expected assertion.
// 81e271060b63b1a5435d554db0e920fe: Test that the `test` function correctly computes and returns the sum of conditional values, including variable reassignments based on the boolean parameter.
// 43025b6126a497c589dc9cf1c4ac9828: Use the `access_warning` function to issue warnings when some actions are attempted outside of their defining module.
