
//# publish
module 0xCAFE::NestedInteractionTest {
    use std::vector;

    struct Counter has store, key {
        count: u64,
    }

    public fun initialize_counter(address: address): () {
        let counter = Counter { count: 0 };
        move_to<Counter>(&signer::borrow_address_as_signer(address), counter);
    }

    public fun increment_counter(address: address): () {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(address);
        counter_ref.count = counter_ref.count + 1;
    }

    public fun get_counter_value(address: address): u64 {
        let counter_ref: &Counter = borrow_global<Counter>(address);
        counter_ref.count
    }

    // Helper to get signer reference from address for move_to
    fun signer_of_address(addr: address): signer {
        // Placeholder function: assumes usage in test context where signer can be obtained appropriately
        // For testing, we can create a dummy signer, but here we just simulate.
        // In actual test, signer would be supplied as arg or managed externally.
        // For the purpose of this example, we leave it as an unimplemented placeholder.
        // (Could be replaced with a dummy or specific signer if the test environment allows.)
        error("not implemented");
    }
}


//# run 0xDEAD::NestedInteractionTest::initialize_counter --args 0xBADD


//# run 0xDEAD::NestedInteractionTest::increment_counter --args 0xBADD


//# run 0xDEAD::NestedInteractionTest::get_counter_value --args 0xBADD


//# publish
module 0xDEAD::ComplexFlow {
    use std::vector;
    use 0xCAFE::NestedInteractionTest;

    public fun complex_sequence(sequence_id: u8): u64 {
        // Block 1: Initialize counter
        if (sequence_id == 1u8) {
            NestedInteractionTest::initialize_counter(0xBADD);
            // Nested block
            {
                // Loop to increment counter 3 times
                let i = 0u8;
                while (i < 3u8) {
                    NestedInteractionTest::increment_counter(0xBADD);
                    i = i + 1;
                };
            };
        } else if (sequence_id == 2u8) {
            // Chain dotted calls with condition dependencies
            let val = NestedInteractionTest::get_counter_value(0xBADD);
            if (val >= 0u64) {
                // Nested condition
                if (val >= 2u64) {
                    NestedInteractionTest::increment_counter(0xBADD);
                };
            };
        } else {
            // Empty block scenario
            { }
        };
        // Final value retrieval
        NestedInteractionTest::get_counter_value(0xBADD)
    }

    public fun nested_module_calls(flag: bool): u64 {
        // Call nested module functions to manipulate state
        if (flag) {
            // Sequence of calls
            NestedInteractionTest::initialize_counter(0xC0FF);
            for (i in 0..2u8) {
                NestedInteractionTest::increment_counter(0xC0FF);
            };
        } else {
            // Chain dotted navigation
            let val = NestedInteractionTest::get_counter_value(0xC0FF);
            if (val > 0u64) {
                NestedInteractionTest::increment_counter(0xC0FF);
            };
        };
        NestedInteractionTest::get_counter_value(0xC0FF)
    }

    public fun complex_condition_evaluation(): bool {
        let val1 = NestedInteractionTest::get_counter_value(0xBADD);
        let val2 = NestedInteractionTest::get_counter_value(0xC0FF);
        // Condition depends on nested module call result
        if (((val1 + val2) >= 5u64) && (val2 >= 1u64)) {
            true
        } else {
            false
        }
    }
}


//# run 0xDEAD::ComplexFlow::complex_sequence --args 1u8


//# run 0xDEAD::ComplexFlow::complex_sequence --args 2u8


//# run 0xDEAD::ComplexFlow::nested_module_calls --args true


//# run 0xDEAD::ComplexFlow::nested_module_calls --args false


//# run 0xDEAD::ComplexFlow::complex_condition_evaluation


// Featurres:
// 4bb18516d182013308cd1c037e8eb3de: Write sequences of statements in Move blocks.
// a99f1ee27e56be90954b5f9b8c8b8ca1: Chain multiple dotted expressions to navigate through nested structures or modules.
// 096995bf2c4c8caed00d42a8669cb5a5: Define specification condition expressions within spec blocks using 'Condition' with an expression and optional additional expressions.
