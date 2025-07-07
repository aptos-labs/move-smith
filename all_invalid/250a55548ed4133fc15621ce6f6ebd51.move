//# publish
module 0xCAFE::ControlFlowTest {
    // Testing break, continue with and without labels, live variable annotations, and direct bytecode handling

    public fun no_label_break_continue() {
        let mut count: u8 = 0;
        while (count < 5) {
            if (count == 3) {
                break;
            };
            count = count + 1;
            if (count == 1) {
                continue;
            };
        };
        // live variables here: count
    }

    public fun labeled_break_continue() {
        let mut i: u8 = 0;
        'outer: while (i < 3) {
            let mut j: u8 = 0;
            'inner: while (j < 3) {
                if (j == 2) {
                    break 'outer;
                };
                if (j == 1) {
                    j = j + 1;
                    continue 'inner;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        // live variables here: i
    }

    // Runner function to invoke both tests with no args
    public fun runner() {
        no_label_break_continue();
        labeled_break_continue();
    }
}

//# run 0xCAFE::ControlFlowTest::runner