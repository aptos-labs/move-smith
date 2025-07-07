// Example transactional test for Aptos Move: constants, 'fun' inference, enums (block/optional comma)

//# publish
module 0xCAFE::TestConstants {
    // 1. Module constants
    // Primitive type
    const U8_CONST: u8 = 42;
    // Vector type
    const VEC_CONST: vector<u8> = b"move";
    // Address type
    const ADDR_CONST: address = @0xBEEF;

    // 2. Omitting the `fun` keyword on function definitions
    public expose_constants(account: &signer) {
        let u = U8_CONST;
        let v = VEC_CONST;
        let a = ADDR_CONST;
        Self::test_enum();
    }

    // 3. Enum declaration featuring block variants & optional commas
    public test_enum() {
        // Enum with block variant and optional commas
        enum MyEnum {
            Number(u64),
            StructLike { field1: u8, field2: bool },
            Empty,
        }

        let a = MyEnum::Number(100);
        let b = MyEnum::StructLike { field1: 7, field2: true };
        let c = MyEnum::Empty;
        // (no assertion: just ensure construction compiles and runs)
    }
}

//# run 0xCAFE::TestConstants::expose_constants --signers 0xCAFE

//# run 0xCAFE::TestConstants::test_enum