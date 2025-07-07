
//# publish
module 0xBADD::TestModule {
    use std::vector;

    // Structs for unpacking tests
    struct InnerStruct has copy, drop {
        a: u8,
        b: u16,
    }

    struct OuterStruct has copy, drop {
        x: u8,
        y: InnerStruct,
    }

    // Importing functions that will be shadowed
    public fun shadowed_func(x: u8): u8 {
        42u8
    }

    // Function that tests unpacking and nested struct assignment
    public fun test_unpack_structs() {
        // Create an instance of OuterStruct
        let outer = OuterStruct {
            x: 1u8,
            y: InnerStruct {
                a: 2u8,
                b: 300u16,
            }
        };
        // Unpack OuterStruct into individual variables
        let OuterStruct { x: xx, y: InnerStruct { a: a1, b: b1 } } = outer;
        assert!(xx == 1u8, 0);
        assert!(a1 == 2u8, 0);
        assert!(b1 == 300u16, 0);
    }

    // Function that tests shadowing imported functions
    public fun test_shadowing() {
        // Local function with same name as imported
        fun shadowed_func(x: u8): u8 {
            // Inside this function, this should shadow imported one
            x
        };
        // Call local shadowed function
        let res_local = shadowed_func(10u8);
        assert!(res_local == 10u8, 0);

        // Call the globally imported function (via fully qualified name)
        let res_imported = 0xBADD::TestModule::shadowed_func(20u8);
        assert!(res_imported == 42u8, 0);

        // Lambda passing a function
        let lambda: |u8| u8 = |x: u8| {
            // Shadowing within lambda
            shadowed_func(x)
        };
        let result_lambda = lambda(15u8);
        assert!(result_lambda == 15u8, 0);
    }

    // Function that tests literals with suffixes and their usage
    public fun test_literals() {
        let a_u8 = 255u8;
        let a_u16 = 65535u16;
        let a_u32 = 4294967295u32;
        let a_u64 = 18446744073709551615u64;
        let a_u128 = 340282366920938463463374607431768211455u128;

        let struct_instance = OuterStruct {
            x: a_u8,
            y: InnerStruct {
                a: a_u8,
                b: a_u16,
            }
        };
        assert!(struct_instance.x == 255u8, 0);
        assert!(struct_instance.y.a == 255u8, 0);
        assert!(struct_instance.y.b == 65535u16, 0);
    }

    // Function that combines fallback of all above features
    public fun complex_test() {
        // Unpack a nested struct with literals and shadowed function
        let input_struct = OuterStruct {
            x: 7u8,
            y: InnerStruct {
                a: 9u8,
                b: 1024u16,
            }
        };

        // Shadowing a function with local parameter
        fun shadowed_func(x: u8): u8 {
            // Still shadowed
            x + 10u8
        };

        // Call with shadowed function and literals
        let _ = shadowed_func(5u8);
        // Validate unpacked values
        let OuterStruct { x: ax, y: InnerStruct { a: a2, b: b2 } } = input_struct;
        assert!(ax == 7u8, 0);
        assert!(a2 == 9u8, 0);
        assert!(b2 == 1024u16, 0);

        // Use literals with suffix in a calculation
        let sum = 100u64 + 200u64 + 300u64;
        assert!(sum == 600u64, 0);
    }
}


//# run 0xBADD::TestModule::test_unpack_structs

//# run 0xBADD::TestModule::test_shadowing

//# run 0xBADD::TestModule::test_literals

//# run 0xBADD::TestModule::complex_test


// Featurres:
// f2ddebe7ab5d5fec40a8fffc3a2b297b: Process positional unpacking of struct fields in Move code, including nested unpacking of variable references.
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
// 3220df2133f8fbcc8780511b273236cf: Use suffixes 'u8', 'u16', 'u32', 'u64', 'u128', or 'u256' to specify the exact numeric type of integer literals in Move code.
