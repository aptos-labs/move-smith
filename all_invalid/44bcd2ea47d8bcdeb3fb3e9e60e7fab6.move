
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;
    use std::signer;

    // Struct with type parameter constrained to 'copy' and 'drop'
    struct TypedStruct<T: copy + drop> has copy, drop {
        value: T,
    }

    // Enum with different variants for pattern matching
    enum PatternEnum has copy, drop {
        VariantA,
        VariantB(u64),
        VariantC { label: bool },
    }

    // Function to test match expressions with pattern bindings and conditions
    public fun test_match(x: u8, detail: PatternEnum): u8 {
        match (detail) {
            PatternEnum::VariantA => 1,
            PatternEnum::VariantB(val) if (val > 10) => 2,
            PatternEnum::VariantB(val) => 3,
            PatternEnum::VariantC { label: true } => 4,
            PatternEnum::VariantC { label: false } => 5,
        }
    }

    // Function to instantiate and return struct with type parameter fixed to u16
    public fun create_typed_struct(): TypedStruct<u16> {
        let ts = TypedStruct { value: 65535u16 };
        ts
    }

    // Function to include a specification block demonstrating 'include'
    public fun spec_inclusion() {
        // Spec block to include external property
        include {
            property: "some_property";
        }
        // Actual implementation, no specific logic
        ()
    }
}



//# run 0xCAFE::FeatureTest::test_match --args 5 "PatternEnum::VariantB(20)"

//# run 0xCAFE::FeatureTest::create_typed_struct

//# run 0xCAFE::FeatureTest::spec_inclusion