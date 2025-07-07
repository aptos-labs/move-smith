
//# publish
module 0xCAFE::NestedTypesTest {
    use std::vector;

    // Complex nested tuple type
    struct ComplexTupleType has copy, drop, store {
        nested_tuple: (u8, (u16, (u32, u64))),
        nested_struct: NestedStruct,
    }

    // Nested struct with multiple fields
    struct NestedStruct has copy, drop, store {
        a: vector<u8>,
        b: (u8, u8),
        c: DeepNestedStruct,
    }

    // Deeply nested struct
    struct DeepNestedStruct has copy, drop, store {
        x: u128,
        y: (u8, (u16, (u32, u64))),
    }

    // Function to create a complex nested structure
    public fun create_complex_structure(): ComplexTupleType {
        let nested_struct_instance = NestedStruct {
            a: vector::empty<u8>(),
            b: (1u8, 2u8),
            c: DeepNestedStruct {
                x: 1234567890u128,
                y: (
                    7u8,
                    (
                        300u16,
                        (
                            4000u32,
                            5000000u64
                        )
                    )
                )
            }
        };

        let complex_tuple_instance = ComplexTupleType {
            nested_tuple: (
                5u8,
                (
                    10u16,
                    (
                        20u32,
                        40u64
                    )
                )
            ),
            nested_struct: nested_struct_instance,
        };
        complex_tuple_instance
    }

    // Function to test destructuring of complex nested structures
    public fun test_destructuring() {
        let c = create_complex_structure();
        // Corrected destructuring: assign to temporary variables for nested tuples
        let (a_byte, nested_inner) = c.nested_tuple;
        let (b_u16, nested_deep) = nested_inner;

        // Destructure nested_struct fields
        let NestedStruct { a, b: (b1, b2), c: deep_struct } = c.nested_struct;

        // Further destructure deep_struct.y
        let (deep_b1, deep_b2_and_c) = deep_struct.y;
        let (deep_b2, deep_c_u32) = deep_b2_and_c;

        // Access to verify correctness
        let deep_x = deep_struct.x;

        // Assertions
        assert!(a_byte == 5u8, 999);
        assert!(b_u16 == 10u16, 999);
        assert!(deep_c_u32 == 20u32, 999);
        assert!(d_u64 == 40u64, 999);
        assert!(b1 == 1u8, 999);
        assert!(b2 == 2u8, 999);
        assert!(deep_x == 1234567890u128, 999);
        assert!(deep_b1 == 7u8, 999);
        assert!(deep_b2 == 300u16, 999);
        assert!(deep_c_u32 == 4000u32, 999);
    }

    // Inline function returning a nested tuple of tuples
    public inline fun nested_tuple_function(x: u8): ((u8, u8), (u16, u32)) {
        (
            (x, x + 1),
            (x as u16 * 10, x as u32 * 100)
        )
    }

    // Function to verify nested_tuple_function output
    public fun verify_nested_tuple() {
        let ((a, b), (c, d)) = nested_tuple_function(3u8);
        assert!(a == 3u8, 888);
        assert!(b == 4u8, 888);
        assert!(c == 30u16, 888);
        assert!(d == 300u32, 888);
    }

    // Function with nested tuple and struct initialization
    public fun init_complex_data(): (NestedStruct, ComplexTupleType, ((u8, u8), (u16, u32))) {
        let nested_struct = NestedStruct {
            a: vector::singleton<u8>(0xff),
            b: (9u8, 8u8),
            c: DeepNestedStruct {
                x: 987654321u128,
                y: (
                    5u8,
                    (
                        255u16,
                        (
                            65535u32,
                            1_000_000_000u64
                        )
                    )
                )
            }
        };
        let complex_object = ComplexTupleType {
            nested_tuple: (
                42u8,
                (
                    84u16,
                    (
                        168u32,
                        336u64
                    )
                )
            ),
            nested_struct: nested_struct,
        };
        let nested_tuple_struct = (
            (1u8, 2u8),
            (3u16, 4u32)
        );
        (nested_struct, complex_object, nested_tuple_struct)
    }

    // Function to validate initialization of complex data
    public fun validate_init() {
        let (n_struct, c_obj, nested_tuple) = init_complex_data();

        // Validate NestedStruct
        assert!(vector::length(&n_struct.a) == 1, 777);
        assert!(vector::borrow(&n_struct.a, 0) == 0xff, 777);
        assert!(n_struct.b.0 == 9u8, 777);
        assert!(n_struct.b.1 == 8u8, 777);
        assert!(n_struct.c.x == 987654321u128, 777);
        assert!(n_struct.c.y.0 == 5u8, 777);
        assert!(n_struct.c.y.1.0 == 255u16, 777);
        assert!(n_struct.c.y.1.1.0 == 65535u32, 777);
        assert!(n_struct.c.y.1.1.1 == 1_000_000_000u64, 777);

        // Validate ComplexTupleType
        assert!(c_obj.nested_tuple.0 == 42u8, 777);
        assert!(c_obj.nested_tuple.1.0 == 84u16, 777);
        assert!(c_obj.nested_tuple.1.1.0 == 168u32, 777);
        assert!(c_obj.nested_tuple.1.1.1 == 336u64, 777);
        assert!(c_obj.x == 1_000_000_000u64, 777);
        assert!(c_obj.y.0 == 5u8, 777);
        assert!(c_obj.y.1.0 == 255u16, 777);
        assert!(c_obj.y.1.1.0 == 65535u32, 777);
        assert!(c_obj.y.1.1.1 == 1_000_000_000u64, 777);

        // Validate nested tuple
        assert!(nested_tuple.0.0 == 1u8, 777);
        assert!(nested_tuple.0.1 == 2u8, 777);
        assert!(nested_tuple.1.0 == 3u16, 777);
        assert!(nested_tuple.1.1 == 4u32, 777);
    }
}



//# run 0xCAFE::NestedTypesTest::test_destructuring


//# run 0xCAFE::NestedTypesTest::verify_nested_tuple


//# run 0xCAFE::NestedTypesTest::validate_init

// Features:
// a9363c0147e2393028a12e3b3ac1a4ca: Fail the compilation process if any errors or diagnostics are encountered.
// f2932ef7e57b033e9b064c17bc55527a: Attach specification blocks directly to code blocks for code-level verification and documentation.
// 2611c2780d4d6685568fe5fc8bca46c8: Incorporate nested tuple and struct types to construct complex data structures with multiple type parameters.
