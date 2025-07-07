
//# publish
module 0xCAFE::ControlFlowTest {
    use std::debug;

    struct Dummy has copy, drop, store {
        val: u8,
    }

    // Test loop with immediate break: executes once and modifies the variable
    public fun loop_with_immediate_break(): u8 {
        let x = 0;
        loop {
            x = x + 1;
            break;
        };
        x
    }

    // Test block label replacement simulation via nested if with labels
    public fun label_replacement_simulation(flag: bool): u8 {
        let result = 0;

        // Outer block label "L1"
        if (flag) {
            // Inner block label "L2"
            let inner_result = 0;
            inner_result = inner_result + 1;
            result = inner_result;
        } else {
            // Here we simulate replacing label reference by just changing control flow
            result = 42;
        };
        result
    }

    // Simulated serialize source map function returning dummy vector
    public fun serialize_source_map(): vector<u8> {
        // Simulate serialization of source map as some bytes
        let source_map = vector[0xC0u8, 0xFFu8, 0xEEu8];
        source_map
    }

    // Runner function to interactively test all above
    public fun runner(): (u8, u8, vector<u8>) {
        let loop_result = loop_with_immediate_break();
        let label_result_true = label_replacement_simulation(true);
        let label_result_false = label_replacement_simulation(false);
        let serialized = serialize_source_map();
        // Return triple demonstrating behavior
        // Note: Use label_result_true only, label_result_false not returned to keep 3 returns max
        (loop_result, label_result_true, serialized)
    }
}


//# run 0xCAFE::ControlFlowTest::loop_with_immediate_break


//# run 0xCAFE::ControlFlowTest::label_replacement_simulation --args true


//# run 0xCAFE::ControlFlowTest::label_replacement_simulation --args false


//# run 0xCAFE::ControlFlowTest::serialize_source_map


//# run 0xCAFE::ControlFlowTest::runner


// Featurres:
// 9d6fa7bbdf4ee46cd979039566ac14fa: Test that a loop with an immediate break correctly executes once and updates the variable accordingly.
// e04f4e6393f3cc70f5b7a7eb7c919001: Replace block or label references with a new label during control flow graph transformations
// 0425835c5696d42eaaf7333cc1c87345: Serialize source maps when requested, associating source code with compiled units.
