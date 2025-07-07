//# publish
module 0xA550C0DE::InlineFunctionsTest {
    /// Inline specification functions for testing purposes.
    public fun inline_create_and_return() {
        // This function creates a variable with inlined functions and returns its value.
        let val = inline_compute_sum(10, 20);
        return val;
    }

    // Function with inline_ prefix to be called directly
    public fun inline_compute_sum(a: u64, b: u64): u64 {
        // Performs addition
        a + b
    }
}

//# run 0xA550C0DE::InlineFunctionsTest::inline_create_and_return --signers 0xA550C0DE --args

//# publish
module 0xA550C0DE::PatternMatching {
    // Function to test '..' pattern matching and destructuring
    public fun match_range_or_destructure(input: u64) {
        // Pattern matching with range '..'
        match input {
            0 ..=10 => {
                // Do nothing
            },
            11 ..=20 => {
                // Do nothing
            },
            _ => {
                // fallback
            }
        }

        // Destructuring a tuple (simulate with structs if needed)
        // For simplicity, just demonstrate pattern matching
    }
}

//# run 0xA550C0DE::PatternMatching::match_range_or_destructure --signers 0xA550C0DE --args 15

//# publish
module 0xA550C0DE::PathConflictTest {
    // Ensure target and dependency paths do not conflict.
    // No functions needed, just structure.
}

//# run 0xA550C0DE::PathConflictTest --signers 0xA550C0DE --args

//# publish
module 0xA550C0DE::StructUnpack {
    // Define a struct only unpacked within this module
    struct MyStruct {
        value1: u64,
        value2: u64,
    }

    // Function to create and unpack the struct
    public fun create_and_unpack() {
        let s = MyStruct { value1: 5, value2: 10 };
        // Unpack only within this module
        let MyStruct { value1, value2 } = s;
        // Just to ensure unpacking works
        let sum = value1 + value2;
        sum
    }
}

//# run 0xA550C0DE::StructUnpack::create_and_unpack --signers 0xA550C0DE --args

//# publish
module 0xA550C0DE::VariableAssignment {
    public fun compute() -> u64 {
        // Initialize variables
        let mut total: u64 = 0;

        // Perform multiple assignments and updates
        total = total + 1;

        // Reassign with update
        total = total + 2;

        // Update again
        total = total + 3;

        total
    }
}

//# run 0xA550C0DE::VariableAssignment::compute --signers 0xA550C0DE --args