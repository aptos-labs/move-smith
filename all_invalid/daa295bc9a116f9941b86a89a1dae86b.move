
//# publish
module 0xCAFE::SpecInlineTest {
    // This module demonstrates inline specification functions (`for_inline`),
    // target path and dependency path separation, and targeting specification blocks.

    use std::string;

    struct Data has key, store {
        value: u64,
    }

    /// Inline specification function -- treated as inline_spec for the Move prover
    // for_inline]
    spec inline fun inline_value(x: u64): u64 {
        x + 100
    }

    /// Regular specification function that calls inline specification function
    spec fun value_plus_10(x: u64): u64 {
        inline_value(x) + 10
    }

    /// Public function that returns value plus 10 to cross-verify specs by executing Move code
    public fun get_value_plus_10(x: u64): u64 {
        inline_value(x) + 10
    }

    /// This function includes a spec block targeting this function to check the spec function usage.
    // spec(target = SpecInlineTest::function_with_spec)]
    spec module {
        /// Dependency spec function with distinct path, does not intersect with target path
        // for_inline]
        spec inline fun dep_increment(x: u64): u64 {
            x + 1
        }
    }

    /// A function with a spec block attached using target notation.
    public fun function_with_spec(x: u64): u64 {
        x * 2
    }

    /// Specification block targeting the `Data` struct (struct variant)
    // spec(target = SpecInlineTest::Data)]
    spec struct Data {
        invariant fun value_nonzero(this: Data): bool {
            this.value > 0
        }
        // for_inline]
        spec inline fun get_double(this: Data): u64 {
            this.value * 2
        }
    }
}


//# run 0xCAFE::SpecInlineTest::get_value_plus_10 --args 5u64


//# run 0xCAFE::SpecInlineTest::function_with_spec --args 7u64


// Featurres:
// 0826263e309bbe8ed6cee2b0c62077ac: Create inline specification functions by setting the 'for_inline' parameter, resulting in functions with 'inline_' prefix in their names.
// 2c618e3c56505dbe76b67552e7796d87: Ensure that target and dependency paths do not intersect to prevent conflicts.
// 1249ce86d777852c3ca977dcfb335bf6: Attach specification blocks to specific Move language constructs using the 'target' mechanism.
