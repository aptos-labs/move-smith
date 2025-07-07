
//# publish
module 0xCAFE::ControlFlowTest {
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
        let debug_str = Vector::empty<u8>();
        Vector::push_back(&mut debug_str, node_start);
        Vector::push_back(&mut debug_str, node_value);
        Vector::push_back(&mut debug_str, node_end);

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


// Featurres:
// 3774a4fbdff54caa4f56e7e2a018e57b: Test that the module correctly computes the sum of three local variables and the assertion passes when calling main.
// 21ac1e75f2dd47f51c2bfced1ce8d74d: Convert AST nodes to a string representation for debugging purposes.
// 227906e22aa321006147337dca6670c1: Use unconditional jumps to transfer control flow to a specified label in Move bytecode.
