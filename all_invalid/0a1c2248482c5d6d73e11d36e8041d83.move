//# publish
module 0xCAFE::AdvancedListParsing {
    use std::vector;

    // Demonstrate behavior of list parsing controlled by closures
    public fun parse_list_with_closures(v: vector<u8>, should_continue: |u8|bool, on_terminate: |u8|) {
        let mut i = 0u64;
        while (i < vector::length(&v)) {
            let value = *vector::borrow(&v, i as u64);
            if (!should_continue(value)) {
                on_terminate(value);
                break;
            };
            i = i + 1;
        };
    }

    public fun runner() {
        let list = vector[1u8, 2u8, 3u8, 4u8, 5u8];

        let continue_predicate = |x: u8| {
            x < 4
        };

        let on_terminate_fn = |x: u8| {
            // Do nothing, just a placeholder to invoke termination
            let _ = x;
        };

        parse_list_with_closures(list, continue_predicate, on_terminate_fn);
    }
}
//# run 0xCAFE::AdvancedListParsing::runner

//# publish
module 0xCAFE::ShadowDestructure {
    // Test variable shadowing with destructuring assignments in nested blocks
    struct Tup has copy, drop {
        a: u8,
        b: u8,
    }

    public fun test_shadowing() {
        let (x, y) = (1u8, 2u8);

        {
            let (x, y) = (10u8, 20u8);
            {
                let (x, y) = (100u8, 200u8);
                // inner shadowing variables (x,y) do not affect outer blocks
                let _ = x + y;
            };
            let _ = x + y; // shadows outer (x,y), inner block ended
        };
        let _ = x + y; // original x,y untouched
    }
}
//# run 0xCAFE::ShadowDestructure::test_shadowing

//# publish
module 0xCAFE::NestedLoopsBreak {
    // Test nested loops with break in inner and outer conditional

    public fun nested_loop_break_test() {
        let mut out_break = false;
        let mut count_outer = 0u8;

        while (!out_break) {
            count_outer = count_outer + 1u8;
            let mut count_inner = 0u8;
            loop {
                count_inner = count_inner + 1u8;

                if (count_inner == 3) {
                    break;
                };

                if (count_inner == 2) {
                    out_break = true;
                    break;
                };
            };
        };
    }
}
//# run 0xCAFE::NestedLoopsBreak::nested_loop_break_test

// Featurres:
// abd25da38d9545b2ed9af23a951107c4: Allow defining specific behaviors for how list parsing continues or terminates by passing in closure functions.
// 5a8683e4815f33ccbf904d0d411d5c78: Test that variable shadowing with destructuring assignments in nested blocks works correctly and independently.
// 12114af09de99c2526fd934eda77cf45: Test that nested loops correctly handle break statements with an outer conditional.
