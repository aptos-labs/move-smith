//# publish
module 0xCAFE::ControlFlowTest {
    // Testing break, continue with and without labels, live variable annotations, and direct bytecode handling

    public fun no_label_break_continue() {
        let mut count = 0u8;
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
        let mut i = 0u8;
        'outer: while (i < 3) {
            let mut j = 0u8;
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

// Featurres:
// fda188fe1ba52851ff503c9efdd2a9d9: Attach the generated compiled bytecode directly to the analysis model after successful compilation.
// efbd2a6d2d9bccdd55ceb521eb042d09: Annotate each code position with the set of live variables at that point in the execution.
// f928cd373a4c5af443bc04af0e5c35a0: Use `break` and `continue` statements with optional labels.
