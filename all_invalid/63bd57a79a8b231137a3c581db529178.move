
//# publish
module 0xCAFE::TestControlFlowAndPatternMatching {
    use std::vector;

    // Testing control flow graph simplification with nested if-else and pattern matching
    public fun control_flow_test(x: u8, y: bool): u8 {
        if (x > 5) {
            if (y) {
                10
            } else {
                20
            }
        } else {
            if (x == 3) {
                30
            } else {
                40
            }
        }
    }

    // Pattern matching over nested enums with variants, named fields, and guards
    public fun match_nested_enum(e: E, flag: bool): u8 {
        match (e) {
            E::V1 => 1,
            E::V2(x, y) if (x + y > 10) => 2,
            E::V2(x, y) => if (x > y) { 3 } else { 4 },
            E::V3 { a } if (a && flag) => 5,
            E::V3 { a } => 6,
        }
    }

    // Using nested property access with dot notation
    public fun nested_property_access(e: E): u8 {
        match (e) {
            E::V3 { a } => if (a) { 1 } else { 0 },
            _ => 0,
        }
    }

    // Additional function to call all above tests for thorough coverage
    public fun runner() {
        let _ = control_flow_test(4, true);
        let _ = control_flow_test(6, false);
        let _ = match_nested_enum(E::V1, true);
        let _ = match_nested_enum(E::V2(8, 3), false);
        let _ = match_nested_enum(E::V2(3, 3), true);
        let _ = match_nested_enum(E::V3 { a: true }, true);
        let _ = nested_property_access(E::V3 { a: false });
    }
}


//# run 0xCAFE::TestControlFlowAndPatternMatching::runner

// Featurres:
// 5d7c61b81a950841df5fc856f19d524b: Simplify control flow graphs to optimize bytecode and potentially remove critical edges.
// b5aba08f0fb25e75add39c5048f6f4dc: Ensure that pattern matching over nested enums, including variants with named fields, wildcards, and guards, correctly handles all cases, including complex nested destructuring and unreachable code detection.
// 379517f1344308eeee004d118d4000bc: Access nested fields or properties using dot notation (e.g., `object.field` or `object.property`).
