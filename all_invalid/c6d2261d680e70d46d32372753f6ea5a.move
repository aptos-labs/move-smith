
//# publish
module 0xCAFE::ReservedNamesTest {
    use std::vector;

    const MODULE_MAGIC: u32 = 0xCADE;

    // Using reserved or restricted names as identifiers
    struct ReservedResource {
        pub addr: address,
        pub value: u64,
    }

    // Function with a deprecated annotation
    public fun use_deprecated_function() {
        // deprecated]
        // deprecated]
        fun deprecated_fn(): u8 {
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

    // Enum with multiple variants
    enum E {
        V1,
        V2 { x: u64 },
        V3 { a: bool },
    }

    // Function returning various balanced complex types
    public fun complex_type_usage() {
        let res = ReservedResource { addr: @0xCAFE, value: 0xDEADBEEFu64 }; 
        // instantiate an enum with multiple variants
        let enum_instance = E::V3 { a: true };
        enum_instance
    }
}



//# run 0xCAFE::ReservedNamesTest::use_deprecated_function --signers 0xBEEF

//# run 0xCAFE::ReservedNamesTest::test_numeric_literals

//# run 0xCAFE::ReservedNamesTest::complex_type_usage