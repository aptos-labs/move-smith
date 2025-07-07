//# publish
module 0x1::spec_blocks {

    // Top-level spec block: Custom spec structure that can contain nested specs or functions
    spec struct TopLevelSpec {
        name: vector<u8>,
        details: vector<u8>,
        nested: vector<spec struct>,
    }

    // Function to create a new top-level spec
    public fun create_top_spec(name: vector<u8>, details: vector<u8>): TopLevelSpec {
        TopLevelSpec {
            name,
            details,
            nested: vector::empty<spec struct>(),
        }
    }

    // Function to add a nested spec to a parent
    public fun add_nested_spec(parent: &mut TopLevelSpec, nested_spec: spec struct) {
        vector::push_back(&mut parent.nested, nested_spec);
    }

    // Example nested spec
    spec struct NestedSpec {
        id: u64,
        description: vector<u8>,
    }

    // Spec function for detailed debug info with bytecode dump name derived from source filename
    public fun dump_source_bytecode_name(source_filename: &vector<u8>) {
        let debug_enabled = true;
        if (debug_enabled) {
            // Derive the bytecode dump name from source filename
            // For simplicity, assume source filename is "test_move.move"
            let dump_name = "bytecode_dump_test_move.move";
            // Log the debug info (simulate with a print)
            // NOTE: In actual testing, this could be /logger API or logs
            move_std::debug(dump_name);
        }
    }

    // Function to declare a literal address specifier with byte sequence
    public fun address_specifier(seq: u8) : address {
        // Declare a literal address using the byte value (0x1234) as an example
        // For illustration, assume seq is used as part of address bytes
        @0x0, 0x0, seq, 0x0 // Just an example; actual address formatting may differ
    }

    // Detect cyclical call paths to prevent infinite recursion during bytecode execution
    module CyclicDetect {
        // Internal set to track call stack
        struct CallStack has store {
            stacks: vector<address>,
        }

        // Push an address onto the call stack
        public fun push(stack: &mut CallStack, addr: address) {
            if (vector::contains<address>(&stack.stacks, addr)) {
                // Cycle detected, revert or panic
                abort 1;
            } else {
                vector::push_back(&mut stack.stacks, addr);
            }
        }

        // Pop an address from the call stack
        public fun pop(stack: &mut CallStack) {
            let length = vector:: length(&stack.stacks);
            if (length > 0) {
                vector::swap_remove(&mut stack.stacks, length - 1);
            }
        }

        // Example recursive function that tracks call stack
        public fun recursive_call(stack: &mut CallStack, current_addr: address, depth: u64) {
            push(stack, current_addr);
            if (depth > 10) {
                // maximum recursion depth reached
                pop(stack);
                return;
            }
            // Simulate recursive call; for test, call with same address to trigger cycle detection
            // or different address to avoid
            if (depth % 2 == 0) {
                recursive_call(stack, current_addr, depth + 1);
            }
            // To test cycle detection, uncomment below:
            // recursive_call(stack, current_addr, depth + 1);
            pop(stack);
        }
    }
}

//# run
script {
    use 0x1::spec_blocks;

    fun main() {
        // Example usage of spec functions to exercise compiler
        // Create a top-level spec
        let top_spec = spec_blocks.create_top_spec(vector::single(0x41), vector::single(0x42));
        // Create a nested spec and add
        let nested = spec_blocks::NestedSpec { id: 42, description: vector::single(0x43) };
        spec_blocks.add_nested_spec(&mut top_spec, spec_struct(nested));

        // Dump source bytecode name for debugging
        spec_blocks::dump_source_bytecode_name(&vector::single(0x64));

        // Declare a literal address specifier
        let addr = spec_blocks::address_specifier(0x34);

        // Detect cyclical call paths
        // Initialize call stack
        let mut call_stack = spec_blocks::CyclicDetect::CallStack { stacks: vector::empty<address>() };

        // Run recursive call to test cycle detection
        spec_blocks::CyclicDetect::recursive_call(&mut call_stack, @0xA550, 0);
    }

    main();
}
//# run 0x1::spec_blocks::dump_source_bytecode_name --args "test_move.move"