//# publish
module 0xDEADBEEF::TestModule {
    use std::debug;
    use std::signer;

    // Spec block for top-level features
    // (No explicit syntax required, documentation or comments can serve as specifications)
    
    // Function to dump bytecode names for debug, simulating detailed logs
    public fun dump_bytecode_name(name: vector<u8>) {
        debug::print(&name);
    }

    // Spec to log debug info including bytecode name derived from source filename
    public fun log_debug_info(file_name: &vector<u8>) {
        debug::print(&file_name);
        // Optionally, dump bytecode name based on source filename
        dump_bytecode_name(file_name);
    }

    // Declaration of a literal address specifier with byte sequence
    public fun declare_literal_address() : address {
        // Using a fixed byte sequence, e.g., 0x01 0x02
        address::from_bytes(&vector[1, 2])
    }

    // Function to compile from stackless bytecode target (simulated by a simple function)
    public fun execute_stackless_bytecode() {
        // Placeholder: simulate execution or deployment
        debug::print(&"Stackless bytecode executed");
    }

    // Inline function accepting reference parameter, called with lambda
    public fun add_with_lambda<F>(val1: u64, val2: u64, f: F) : u64
        where F: FnOnce(&u64, &u64): u64 {
        f(&val1, &val2)
    }

    // Runner function to test inline function with lambda performing addition
    public fun run_addition_test() {
        let result = add_with_lambda(10, 20, |a, b| *a + *b);
        debug::print(&vector[b"Add result: ", b, result]);
    }
}

// //# run 0xDEADBEEF::TestModule::run_addition_test --signers 0x0
//# run 0xDEADBEEF::TestModule::log_debug_info --args b"source_move_file.move"
/* Additional scripts to test:
   - Including the top-level spec blocks (implied via functions or comments)
   - Logging detailed debug info
   - Declaring a literal address with byte sequence
   - Using a stackless bytecode simulation
   - Calling the inline function with lambda for addition
*/