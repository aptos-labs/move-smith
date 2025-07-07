
//# publish
module 0xCAFE::ReservedNamesTest {
    use std::vector;

    const MODULE_MAGIC: u32 = 0xCADE;

    // Using reserved or restricted names as identifiers
    struct ReservedResource {
        pub address: address,
        pub value: u64,
    }

    // Function with a deprecated annotation
    public fun use_deprecated_function() {
        // deprecated]
        public fun deprecated_fn(): u8 {
            42u8
        }
        // Call deprecated function
        let _ = deprecated_fn();
        ()
    }

    // Function with typed numeric literals directly as values
    public fun test_numeric_literals() {
        let a = 12345u16; // directly as u16
        let b = 1234567890u32; // directly as u32
        let c = 1234567890123456789u64; // directly as u64
        (a, b, c)
    }

    // Function returning various balanced complex types
    public fun complex_type_usage() {
        let res = ReservedResource { address: @0xCAFE, value: 0xDEADBEEFu64 }; 
        // instantiate an enum with multiple variants
        let enum_instance = E::V3 {a: true};
        enum_instance
    }
}


//# run 0xCAFE::ReservedNamesTest::use_deprecated_function --signers 0xBEEF
// The above call exercises the deprecated annotation and should compile and run, calling the deprecated function.


//# run 0xCAFE::ReservedNamesTest::test_numeric_literals
// This tests that typed literals are correctly parsed and assigned without errors.


//# run 0xCAFE::ReservedNamesTest::complex_type_usage
// This tests usage of complex types and various enum variants with proper initialization.

// Featurres:
// f7f2352953dc3c35286e268ed8e08272: Avoid using restricted or reserved names for identifiers in your Move code
// bf9d6723bbe3a98f8af6efcf0b0e836f: Write typed numeric literals directly as values, such as with a specific suffix.
// a2f2e27ab6ea98b68b7f88736898536b: Annotate module members as deprecated using the #[deprecated] annotation.
