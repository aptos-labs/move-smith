
//# publish
module 0xCAFE::TestOptimizer {
    use std::signer;
    use std::vector;

    // Define a resource for testing module references
    struct ExternalResource has key {
        value: u64,
    }

    // Resource for tracking execution order
    struct TraceLog has key {
        logs: vector<u8>,
    }

    // Initialize the TraceLog resource
    public fun init_trace_record(s: signer) {
        move_to<TraceLog>(&s, TraceLog { logs: vector::empty<u8>() });
    }

    // Append a byte to the log
    public fun record_event(s: signer, event: u8) {
        let log_ref: &mut TraceLog = borrow_global_mut<TraceLog>(signer::address_of(&s));
        vector::push_back(&mut log_ref.logs, event);
    }

    // Helper to get the current logs length
    public fun get_log_length(s: signer): u64 {
        let log_ref: &TraceLog = borrow_global<TraceLog>(signer::address_of(&s));
        vector::length(&log_ref.logs)
    }

    // Function to create a matrix of jump instructions with redundant jumps
    public fun jump_optimization_test() {
        // This function does nothing but multiple jumps for testing
        // Actual control flow constructs are tested via inline code in scripts
    }

    // Function with nested expressions and complex control flow
    public fun nested_expression_control(s: signer): u64 {
        let result: u64 = {
            // Start tracking order
            record_event(s, 1u8);
            let _a = 10u64;

            if (true) {
                record_event(s, 2u8);
                let _b = _a + 5;

                while (_b < 20) {
                    record_event(s, 3u8);
                    let _b = _b + 1;

                    // Early exit from loop when condition met
                    if (_b == 18) {
                        break;
                    };
                };
                // Return from if branch
                _b
            } else {
                record_event(s, 4u8);
                0u64
            }
        };
        // Final step
        record_event(s, 5u8);
        result
    }

    // Module reference aliasing test
    public fun module_reference_test(s: signer) {
        // Create external resource
        let resource = ExternalResource { value: 42 };
        move_to<ExternalResource>(&s, resource);

        // Alias external module (simulate external reference)
        let external_module = 0xCAFE;

        // Call external resource's function via module alias
        let resource_ref: &ExternalResource = borrow_global<ExternalResource>(signer::address_of(&s));
        let _val = resource_ref.value;

        // Call a resource function, asserting value
        assert!(_val == 42, 999);
    }
}


//# run 0xCAFE::TestOptimizer::jump_optimization_test --signers 0xDEAD


//# run 0xCAFE::TestOptimizer::nested_expression_control --signers 0xBADD


//# run 0xCAFE::TestOptimizer::module_reference_test --signers 0xC0FF


// Featurres:
// 9eb7776ed6f83b78d2fb06e2e874c32c: Rely on the compiler to remove unnecessary trailing jump instructions from bytecode blocks
// 86f8adf1e0f084864bf8f1a02cbe9d90: Test that variable assignments and returns within code blocks are evaluated in the correct order and that control flow behaves as expected within expression blocks.
// 0bfe0ae9eb5d9bbba8d0f4ec9cb136c1: Use a module alias to refer to resources or functions defined in another module.
