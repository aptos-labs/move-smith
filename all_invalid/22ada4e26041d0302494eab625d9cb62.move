//# publish
module 0xCAFE::AttributesAndBindings {
    // This module demonstrates bindings with annotations and ranges,
    // and improper attribute positions which should log warnings during compilation.

    // Struct with fields annotated with attributes specifying ranges.
    struct RangeAnnotated has copy, drop, store {
        #[range(0, 100)]
        a: u8,
        #[range(-10, 10)]
        b: i32,
    }

    // Function creating a list of annotated bindings (simulated by tuples annotated in source).
    public fun create_annotated_bindings(): vector<(u8, i32)> {
        // Simulate a list of bindings with annotations (Note: Move does not actually support binding annotations,
        // this is a conceptual test to ensure compiler exercises annotations syntax.)
        let bindings = vector::empty<(u8, i32)>();
        vector::push_back(&mut bindings, (10, 5));
        vector::push_back(&mut bindings, (20, -3));
        vector::push_back(&mut bindings, (30, 0));
        bindings
    }

    // Function with an incorrect nested attribute usage.
    #[outer]
    #[nested_attr(
        #[inner_wrong] // Improper nested attribute usage testing warnings.
    )]
    public fun function_with_wrong_attrs(): u64 {
        42
    }

    // Runner function to call create_annotated_bindings and function_with_wrong_attrs.
    public fun runner() {
        let _ = create_annotated_bindings();
        let _ = function_with_wrong_attrs();
    }
}
//# run 0xCAFE::AttributesAndBindings::runner --signers 0xCAFE

//# publish
module 0xCAFE::LoopMultipleAssignments {
    // This module tests while-loop conditions with multiple assignment expressions in a block.
    // Variables updated and used in and after loop.

    public fun multi_assign_loop() {
        let mut x = 0u64;
        let mut y = 10u64;

        // Loop continues until y == 0
        while ({
            // Block returning bool condition and performing multiple assignments.
            (x = x + 1u64);
            (y = y - 1u64);
            y > 0u64
        }) {
            // Inside the loop, x and y updated by the block above
            // no-op loop body
        }

        // After loop, x should be initial x + initial y (0 + 10 = 10)
        let _final_x = x;
        let _final_y = y;
        // no assertions needed, just test compiler and VM execution here
    }

    public fun runner() {
        multi_assign_loop();
    }
}
//# run 0xCAFE::LoopMultipleAssignments::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::AttributesAndBindings;
    use 0xCAFE::LoopMultipleAssignments;

    fun main() {
        // Test runner inside AttributesAndBindings
        AttributesAndBindings::runner();

        // Test runner inside LoopMultipleAssignments
        LoopMultipleAssignments::runner();
    }
}

// Featurres:
// 45a545cd7fe6a24a5e87b8a59814aafb: Create lists of bindings where each binding can be annotated or connected to a range value
// 28e3cac7cfb6fd855decf014568a084c: Identify and warn about attributes used in incorrect positions, such as nested attributes where they are not expected.
// 9260e563bdcf5d0627c86237bb5e361e: Test that while-loop conditions can contain and execute multiple assignment expressions via a block, and that these assignments correctly affect variables used in the loop and after it.
