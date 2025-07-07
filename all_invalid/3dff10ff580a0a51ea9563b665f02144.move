
//# publish
module 0xCAFE::BytecodeDump {
    use std::debug;
    use std::signer;

    /// Function to simulate dumping bytecode of this function at runtime using debug print
    /// (Note: Move does not support direct bytecode access, so we simulate with debug messages)
    public fun dump_bytecode_simulation() {
        debug::print(b"--- Dumping bytecode simulation for dump_bytecode_simulation ---");
    }

    /// Function that exercises ability constraints on a function type parameter
    /// T must have copy + drop so that it can be safely copied and dropped inside the function
    public fun ability_constraints_example<T: copy + drop>(input: T): T {
        let copy_input = copy input;
        copy_input
    }

    /// Demonstrate binary operations with simple, side-effect-free operands
    public fun binary_operations_simple(x: u8): u8 {
        let a = 3u8;
        let b = 4u8;
        // only use simple constants and variables without side-effects in the operations
        let sum = a + b;
        let diff = b - a;
        let mul = a * b;
        let div = b / (a + 1u8);
        let res = sum + diff + mul + div + x;
        res
    }
}


//# run 0xCAFE::BytecodeDump::dump_bytecode_simulation


//# run 0xCAFE::BytecodeDump::ability_constraints_example --args 42u8


//# run 0xCAFE::BytecodeDump::binary_operations_simple --args 10u8


// Featurres:
// 6368e3be802f97bc891c1d6ad6d9ce48: Automatically dump the bytecode of functions during pipeline execution for debugging purposes.
// c58ec5bcad183e685aa4157b1ddd27cf: Specify ability constraints (such as copy, drop, store) on function type parameters.
// 2360cbea0e5eb31f65d04ff043002c70: Write binary operations only with simple, side-effect-free operands to avoid obscuring program logic.
