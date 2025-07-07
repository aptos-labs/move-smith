
//# publish
module 0xABCD::AdvancedFeatures {
    // Basic complex nested structs for dot notation tests
    struct InnerStruct has copy, drop, store {
        a: u32,
        b: bool,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        value: u64,
    }

    // Module nested under address namespace to test deprecation attribute
    //* Deprecated address namespace
    // deprecated]
//# publish
    module 0xABCD::DeprecatedNamespace {
        public fun dummy_deprecated() {
            // no-op
        }
    }

    // Function to test first-class function behaviors
    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun identity<T>(x: T): T {
        x
    }

    // Function with specification annotations
    public fun spec_function(x: u64): u64 {
        x + 1
    }
}


//# publish
module 0x1234::InteractionTests {
    use 0xABCD::AdvancedFeatures;

    // Function to access nested fields via dot notation
    public fun get_inner_b(val: AdvancedFeatures::OuterStruct): bool {
        val.inner.b
    }

    // Function to test deprecation attribute inheritance
    public fun call_deprecated_module() {
        0xABCD::DeprecatedNamespace::dummy_deprecated()
    }

    // Function to assign functions to variables and invoke
    public fun function_as_value() {
        let f: fn(u8, u8) -> u8 = AdvancedFeatures::add_u8;
        let result = f(2, 3);
        let id_fn: fn<U8, U8> -> U8 = AdvancedFeatures::identity;
        let v = id_fn(5u8);
        let res2 = id_fn::<u8>(9u8);
    }

    // Function to pass functions as arguments
    public fun call_with_function(f: fn(u8, u8) -> u8) {
        let res = f(4, 5);
        res
    }

    // Function to invoke generic function with different types
    public fun invoke_generic() {
        let add_fn: fn(u64, u64) -> u64 = AdvancedFeatures::add_u64;
        let res1 = add_fn(10, 20);
        let id_fn: fn<U8, U8> -> U8 = AdvancedFeatures::identity;
        let v = id_fn(7u8);
    }

    // Function to verify spec block referencing
    public fun verify_spec() {
        // Placeholder for spec verification
        // Assume this function references a spec block
    }
}

// The actual test code for control flow, first-class functions, deprecation, and specs

let outer = AdvancedFeatures::OuterStruct {
    inner: AdvancedFeatures::InnerStruct { a: 42, b: true },
    value: 100u64,
};
let inner_b = 0x1234::InteractionTests::get_inner_b(outer);

// Test deprecation attribute on namespace & module
0x1234::InteractionTests::call_deprecated_module();

// Assigning functions as first-class values, invoking, and passing as args
let f_concat: fn(u8, u8) -> u8 = AdvancedFeatures::add_u8;
let _result1 = f_concat(1, 2);
let id_fn: fn<U8, U8> -> U8 = AdvancedFeatures::identity;
let _v1 = id_fn(8u8);
0x1234::InteractionTests::call_with_function(f_concat);

// Invoke generic function with different types
0x1234::InteractionTests::invoke_generic();

// Verify spec block call (assuming spec block is defined elsewhere)
0x1234::InteractionTests::verify_spec();

// Test deprecation inheritance: call a module from deprecated namespace
0x1234::InteractionTests::call_deprecated_module();

// Bytecode control flow: conditional branch testing
public fun control_flow_test(flag: bool): u64 {
    if (flag) {
        label_true:
        let x = 10u64;
        x
    } else {
        label_false:
        let y = 20u64;
        y
    }
}

// Spec block with pragma properties (pseudo-annotations for illustration)
// pragma_property: "test_case"]
public fun annotated_spec() {
    // This function would have a spec block with properties
    // e.g., specifying behavior and meta information
}

// Additional tests for edge cases
public fun nested_deprecation_and_struct() {
    // Use nested deprecated module
    0xABCD::DeprecatedNamespace::dummy_deprecated();

    // Access nested fields of struct with dot notation
    let s = AdvancedFeatures::OuterStruct {
        inner: AdvancedFeatures::InnerStruct { a: 0, b: false },
        value: 0,
    };
    let _inner_b = s.inner.b;
}


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 14993c742de74b563f9623fbba7a7bb3: Use conditional branches that direct control flow to one of two labels based on a condition in Move bytecode.
// d1bbf3857e5f006138bfcfc503194902: Avoid defining inline functions inside scripts.
// afa4237eee3de0f7590f7d3a63c5656f: Annotate spec blocks and members with pragma properties for meta-information or tool directives.
