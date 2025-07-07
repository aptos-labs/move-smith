
//# publish
module 0xCAFE::BytecodeDump {
    // Removed `use std::debug;` as it's not available in Aptos Move

    /// Function to simulate dumping bytecode of this function at runtime
    /// (Note: Move does not support direct bytecode access, so we simulate with abort)
    public fun dump_bytecode_simulation() {
        abort 0; // Just abort to indicate execution reached here
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


//# run 0xCAFE::BytecodeDump::ability_constraints_example<u8> --args 42u8


//# run 0xCAFE::BytecodeDump::binary_operations_simple --args 10u8
