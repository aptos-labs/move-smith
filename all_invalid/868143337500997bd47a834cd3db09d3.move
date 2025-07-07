
//# publish
module 0xCAFE::TestPatternMatching {
    use std::vector;

    // Deprecated constant to test deprecation annotation
    // deprecated]
    const DEPRECATED_CONST: u32 = 42;

    struct Point has copy, drop {
        x: u64,
        y: u64,
    }

    struct NamedPoint has copy, drop {
        x: u64,
        y: u64,
    }

    // Function to perform pattern matching with tuple pattern and destructure a struct
    public fun match_struct_and_patterns(p: Point): u64 {
        // Pattern match on struct with named fields
        let result = match (p) {
            Point { x, y } => {
                // Using explicit field access and addition
                x + y
            }
        };
        result
    }

    // Function to test matching with references and destructure options
    public fun match_reference_and_borrow(p: &Point): u64 {
        let result = match (p) {
            &Point { x, y } => {
                x * y
            }
        };
        result
    }

    // Function to test pattern matching with nested options and references
    public fun nested_pattern_match(opt: &option<Point>): u64 {
        let result = match (opt) {
            &Some(Point { x, y }) => {
                x + y
            }
            &None => {
                0
            }
        };
        result
    }

    // Function to test pattern matching with enum variant, with type abilities
    public fun match_enum_and_deprecated(e: E): u64 {
        // Use deprecated constant
        let _ = DEPRECATED_CONST;
        let result = match (e) {
            E::V1 => 1,
            E::V2(x, y) => x + y,
            E::V3 { a } => {
                if (a) { 100 } else { 200 }
            }
        };
        result
    }

    // Function to test pattern matching with let bindings on struct
    public fun let_binding_struct(p: Point): u64 {
        let Point { x: a, y: b } = p;
        a + b
    }

    // Function to test pattern matching with references and let binding
    public fun let_binding_ref(p: &Point): u64 {
        let &Point { x: a, y: b } = p;
        a * b
    }

    // Function to test nested pattern matching with tuples
    public fun nested_tuple_matching(x: (u8, u8), y: (u16, u16)): u16 {
        let (a, b) = x;
        let (c, d) = y;
        // combine into one value
        (a as u16) + c
    }
}

// Enums needed for the above patterns
enum E has copy, drop {
    V1,
    V2(u32, u32),
    V3 { a: bool }
}

// Additional interface file for dependency examples
// (Assuming the dependency interface is simple and to be included)
module 0xDEAD::DependencyInterface {
    public fun dep_function(x: u64): bool;
}


//# run 0xCAFE::TestPatternMatching::match_struct_and_patterns --args 0u64

//# run 0xCAFE::TestPatternMatching::match_reference_and_borrow --args 0x00u64

//# run 0xCAFE::TestPatternMatching::nested_pattern_match --args 0x01u8 0x02u8

//# run 0xCAFE::TestPatternMatching::match_enum_and_deprecated --args E::V2(5, 10)

//# run 0xCAFE::TestPatternMatching::let_binding_struct --args Point { x: 4, y: 5 }

//# run 0xCAFE::TestPatternMatching::let_binding_ref --args &Point { x: 7, y: 8 }

//# run 0xCAFE::TestPatternMatching::nested_tuple_matching --args (1u8, 2u8) (100u16, 200u16)

// Featurres:
// 9d446a052e07802cc55f6d13ba427760: Test that struct pattern matching and field projection—both via tuple-style and named-field patterns, for owned values and references, and with and without type abilities—works correctly in function bodies and lets bindings.
// 2727731fcfe3c6a7fa9707320adbd25a: Mark member items (such as functions, structs, or constants) as deprecated using Move's #[deprecated] annotation to signal their deprecation to users.
// ff7fef94430f872ddd1dfaa628a1dabc: Generate interface files for dependencies and include them in the dependency list.
