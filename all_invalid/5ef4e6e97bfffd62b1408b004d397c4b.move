
//# publish
module 0xCAFE::ControlFlowTest {
    use std::vector;
    use std::debug;

    public fun main() {
        let a = 10u8;
        let b = 20u8;
        let c = 30u8;

        let sum = a + b + c;
        assert!(sum == 60, 1000);

        // Use debug::print to output a string literal for debugging
        debug::print(b"Sum computed successfully\n");
    }

    public fun ast_node_to_string_debug() {
        // Simulate AST nodes as simple u8 tags
        let node_start = 1u8;
        let node_end = 2u8;
        let node_value = 3u8;

        // Compose a vector<u8> which will simulate a debug string of AST node tags
        let debug_str = vector::empty<u8>();
        vector::push_back(&mut debug_str, node_start);
        vector::push_back(&mut debug_str, node_value);
        vector::push_back(&mut debug_str, node_end);

        debug::print(&debug_str);
    }

    native public fun u64_to_u8(u: u64): u8;

    public fun unconditional_jump(_x: u8) {
        // Inspired by unconditional jump concept
        // We simulate jump by an if...else with an always false condition
        // and a label outside

        if (false) {
            // This block never executes simulating jump skip
            let _dummy = 0;
        } else {
            // This else block runs unconditionally
            debug::print(b"Jump target reached\n");
        };
    }
}



//# run 0xCAFE::ControlFlowTest::main



//# run 0xCAFE::ControlFlowTest::ast_node_to_string_debug



//# run 0xCAFE::ControlFlowTest::unconditional_jump --args 42u8
