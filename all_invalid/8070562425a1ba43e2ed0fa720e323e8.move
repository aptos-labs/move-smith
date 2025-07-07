//# publish
module 0x1::TestModule {
    use std::debug;

    // 1. Create an address specifier with no content using empty parentheses, e.g., '()'.
    // In Move, `address` literals can be empty if using `()` as a no-content address specifier.
    // We demonstrate it here by defining a const address with ().
    const EMPTY_ADDRESS: address = ();

    // 2. Create a source location object with a specific file hash, start, and end positions
    // SourceLocation has fields: file_hash (vector<u8>), start (u64), end (u64).
    // We create one with explicit content.
    struct SourceLocation has copy, drop, store {
        file_hash: vector<u8>,
        start: u64,
        end: u64,
    }

    public fun create_source_location(): SourceLocation {
        let file_hash = b"example_hash";
        SourceLocation {
            file_hash,
            start: 10,
            end: 50,
        }
    }

    // 3. Implement fall-through control flow.
    // Move bytecode allows implicit fall-through if no jump is taken.
    // We implement a function demonstrating fall-through by sequentially executing instructions without jumps.
    public fun fall_through_example(): u64 {
        let mut acc = 0u64;

        // First block: add 10
        acc = acc + 10;

        // No explicit jump, so the function "falls through" to next instruction.

        // Second block: add 20
        acc = acc + 20;

        // Again, fall-through without jumps.

        // Third block: add 30
        acc = acc + 30;

        // Return accumulated result: 60
        acc
    }

    // Runner function that calls all tests with no arguments.
    public fun run_all(): u64 {
        let sl = create_source_location();
        // Just debug print the file_hash length so we "use" sl (to avoid warnings).
        debug::print(&sl.file_hash);
        let ft = fall_through_example();

        // Return the fall_through_example result which should be 60.
        ft
    }
}


//# run 0x1::TestModule::run_all