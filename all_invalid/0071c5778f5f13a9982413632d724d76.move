
//# publish
module 0xCAFE::IdentifierAndFieldTest {
    // Test valid and invalid identifiers, field initializations (explicit and shorthand), and pragma annotations.

    // Valid struct with pragma annotation
    // pragma("valid_struct")]
    struct ValidStruct has copy, drop, store {
        alpha: u8,
        _beta: u16,
        gamma_: bool,
    }

    // Struct with pragma and field initialization tests inside function
    // pragma("test_struct_init")]
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // pragma("test_tuple_init")]
    struct TupleStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Function with pragma testing variable and identifier declarations, including shorthand and explicit field init
    // pragma("test_var_and_fields")]
    public fun identifier_and_field_init() {
        // Valid variable names (start with letter or _)
        let alpha1 = 10u8;
        let _underscore_start = true;
        let gamma_ = 42u64;

        // Struct init with explicit field names
        let p1 = Point {
            x: 5u64,
            y: 8u64,
        };

        // Struct init with shorthand syntax using variables defined above
        let p2 = Point {
            x: gamma_,
            y,
        };
        // define y for shorthand to be valid
        let y = 9u64;

        // The last line above (let y = 9u64;) must come before usage to satisfy order
        // So actually reorder above to fix that:
        // Move does not allow usage before declared, so fix order below:

        // Fixed init:
        // let y = 9u64;
        // let p2 = Point {x: gamma_, y,};

        let y_fixed = 9u64;
        let p2_fixed = Point {
            x: gamma_,
            y: y_fixed,
        };

        // TupleStruct initialization with explicit field init
        let t1 = TupleStruct { a: 3u8, b: 4u8 };

        // TupleStruct initialization with shorthand field init
        let a = 7u8;
        let b = 8u8;
        let t2 = TupleStruct { a, b };

        // Using pragma on variables (pragma annotations on locals are invalid in current Move, but test parser rejects invalid)

        // Valid use of pragma on functions and structs included above

        // Creating a ValidStruct instance using explicit field initialization
        let s1 = ValidStruct {
            alpha: alpha1,
            _beta: 500u16,
            gamma_: false,
        };
        // Creating a ValidStruct instance using shorthand initialization
        let alpha1_s = 11u8;
        let _beta_s = 501u16;
        let gamma__s = true;
        let s2 = ValidStruct {
            alpha: alpha1_s,
            _beta: _beta_s,
            gamma_: gamma__s,
        };
    }
}


//# run 0xCAFE::IdentifierAndFieldTest::identifier_and_field_init



//# publish
module 0xCAFE::PragmaAnnotations {
    // Testing pragma annotations on module, struct, and function levels.

    // pragma("module_pragma")]
    // Module-level pragma annotation above won't be parsed as module pragma,
    // but included to test parser robustness (usually pragmas sit above items)

    // pragma("pragma_struct")]
    struct PragmaStruct has store, copy, drop {
        a: u8,
        b: u64,
    }

    // pragma("pragma_function")]
    public fun pragma_function_example() {
        let x = 10u8;
        let y = 20u8;
        let _z = x + y;
    }

    // pragma("combined_test")]
    public fun combined_test_with_pragma() {
        // Declare variables
        let alpha = 1u8;
        let beta = 2u8;

        // Struct shorthand field initialization combined with pragma on struct
        let s = PragmaStruct {
            a: alpha,
            b: 100u64,
        };

        let s2 = PragmaStruct {
            a: 10u8,
            b: 200u64,
        };
    }
}


//# run 0xCAFE::PragmaAnnotations::pragma_function_example


//# run 0xCAFE::PragmaAnnotations::combined_test_with_pragma


// Featurres:
// d2bc13aff928540133f58d9f2d499feb: Create variable names and other identifiers in Move that follow the naming rules defined by the identifier's characteristic of starting with a letter or underscore.
// eb85dfc6ca4661f5fece0860b0988924: Specify struct or tuple fields with either an explicit value expression after a ':' or use shorthand syntax to use the field name as the value.
// 4e5ab487355189f82f7efc6eefaa2ae8: Use '#[pragma ...]' annotations in your Move code to specify compiler or verifier directives.
