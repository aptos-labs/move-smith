//# publish
module 0xCAFE::BasicBlocks {
    // A struct with multiple abilities.
    // Testing explicit type abilities declaration using 'has'.
    struct Data has copy, drop, store {
        value: u64,
    }

    // Function illustrating explicit basic blocks with control flow between them.
    public fun example_control_flow(flag: bool): u64 {
        let mut result = 0;

        // Basic Block 0: entry
        if (flag) {
            // Basic Block 1
            result = 10;
        } else {
            // Basic Block 2
            result = 20;
        };

        // Basic Block 3: exit
        result + 5
    }

    // Runner function with no args which can be invoked in tests
    public fun runner(): u64 {
        // run example_control_flow with flag true and false
        let res_true = example_control_flow(true);
        let res_false = example_control_flow(false);
        // Just sum results to have some consistent output
        res_true + res_false
    }
}

//# run 0xCAFE::BasicBlocks::runner


//# run
script {
    use 0xCAFE::BasicBlocks;

    fun main() {
        let val_true = BasicBlocks::example_control_flow(true);
        let val_false = BasicBlocks::example_control_flow(false);

        // Dummy print simulation - prints are not supported but we call functions anyway
        // actual test frameworks will check side effects or returns.
        // No assertions per requirements.
        let _ = val_true;
        let _ = val_false;
    }
}

// Featurres:
// 68914556f4c8cfe84aa2f4d67fb0e28a: Design Move code with explicit basic blocks that are connected by control flow edges representing possible executions
// 04a0c8595d70719671ccf6bc64624606: Declare type abilities (such as 'copy', 'drop', 'store', or 'key') using the 'has' keyword on structs
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
