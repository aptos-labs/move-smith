// File-level comment for the module SpecTest
// This module tests module-level spec block and nested loops



//# publish
module 0xCAFE::SpecTest {
    use std::vector;

    struct Data has copy, drop, store {
        val: u8,
    }

    public fun new_data(x: u8): Data {
        Data { val: x }
    }

    public fun nested_loop_test(limit: u8): u8 {
        let counter = 0u8;
        let i = 0u8;
        while (i < limit) {
            let j = 0u8;
            while (j < limit) {
                if (i + j > limit) {
                    break;
                };
                counter = counter + 1;
                j = j + 1;
            };
            if (counter > limit) {
                break;
            };
            i = i + 1;
        };
        counter
    }

    spec {
        invariant forall<i: u8, j: u8> where i < 5 && j < 5 {
            // Example invariant across all data instances could be here
            (i + j) >= 0
        }
        fun test_spec(): bool {
            true
        }
    }
}



//# run 0xCAFE::SpecTest::nested_loop_test --args 5u8


// Featurres:
// b44775bbdd8e5ba940595bad7170c885: Group one or more specification block members inside a module-level spec block
// dd5ae49180662dd16ec747e5d90fd681: Write Move source files that can include file-level comments matched to code definitions.
// 12114af09de99c2526fd934eda77cf45: Test that nested loops correctly handle break statements with an outer conditional.
