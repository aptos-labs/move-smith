//# publish
module 0x1::inline_specification {
    /// Function to create an inline specification function with 'inline_' prefix.
    public fun inline_create_for_inline(for_inline: bool): bool {
        // Return the value of for_inline to verify inline function behavior.
        for_inline
    }

    /// Function demonstrating pattern matching with '..' pattern.
    public fun pattern_match_range(value: u64): u8 {
        // Match value against a range using '..' syntax.
        match value {
            0 ..= 99 => 1,
            100 ..= 199 => 2,
            _ => 0,
        }
    }

    /// Function to ensure that target and dependency paths do not intersect.
    public fun check_paths(target_path: vector<u8>, dependency_path: vector<u8>): bool {
        // Check that paths do not intersect; in this simplified test, ensure they are not equal.
        // For more complex intersection logic, more code would be needed.
        target_path != dependency_path
    }

    /// Runner function to exercise inline creation.
    public fun run_inline_creation(): bool {
        inline_create_for_inline(true)
    }

    /// Runner function to exercise pattern matching with range.
    public fun run_pattern_match(): u8 {
        pattern_match_range(150)
    }

    /// Runner function to exercise path intersection logic.
    public fun run_path_check(): bool {
        check_paths(b"target".to_vector(), b"dependency".to_vector())
    }
}

//# run 0x1::inline_specification::run_inline_creation --signers 0x1
//# run 0x1::inline_specification::run_pattern_match
//# run 0x1::inline_specification::run_path_check