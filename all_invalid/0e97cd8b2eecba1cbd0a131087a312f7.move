
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Declare a struct with copy, drop, store, key abilities
    struct ResourceA has copy, drop, store, key {
        data: u64,
    }

    // Declare a regular struct with same abilities
    struct StructB has copy, drop, store {
        value: bool,
    }

    // Declare a generic struct with abilities
    struct GenericStruct<T> has copy, drop, store {
        field: T,
    }

    // Declare an enum with copy, drop abilities
    enum EnumC has copy, drop {
        Variant1,
        Variant2(u8, u8),
        Variant3 { flag: bool },
    }

    // Function to test inline with no body (should be removed)
    public inline fun inline_no_body<T>() {
    }

    // Function that relies on compiler error reporting configuration
    public fun cause_error() {
        // purposely cause a compilation error by redeclaring a struct in the same module
        // This will generate an error (simulating the feature)
        struct ResourceA {
            duplicate: u8,
        }
    }

    // Function with configuration for error output (non-standard, just to replicate point 3)
    public fun report_errors_to(writer: u64) {
        // placeholder for error reporting configuration, assuming custom error output functions exist
        // no actual code as this is illustrative
    }

    // Function to instantiate all types above
    public fun test_instances() {
        let _res = ResourceA {data: 42};
        let _struct_b = StructB {value: true};
        let _generic = GenericStruct<u8> {field: 255};
        let _enum = EnumC::Variant2(1, 2);
        // Invoke inline function, should be removed
        inline_no_body::<u64>();
    }
}


//# run 0xCAFE::FeatureTest::test_instances --signers 0x0 --args

// Featurres:
// c0e5f1c148842980e7b90e85dc8b4add: Declare struct or resource types with the abilities: Copy, Drop, Store, and Key by using the respective ability names in Move code.
// 90664d4b2d8c8d0427947c5eb3a9aa52: Rely on the compiler to remove inline functions with bodies from the final program, preventing code generation issues with certain constructs.
// 998fbe7952135a22ff05716135a83301: Configure error reporting to output errors to a specified writer.
