
//# publish
module 0xCAFE::StructModule {
    struct MyStruct {
        value: u64,
        name: vector<u8>,
    }

    // Expose a public function to access the `value` field
    public fun get_value(s: &MyStruct): u64 {
        s.value
    }

    // Expose a public function to access the `name` field
    public fun get_name(s: &MyStruct): vector<u8> {
        s.name
    }

    // A function that attempts to access a private field (should be invalid outside if not exposed)
    // Not added as public, to ensure outside modules cannot directly access fields
}

module 0xCAFE::EnumModule {
    enum MyEnum {
        VariantA { num: u8 },
        VariantB,
    }

    // Expose a function to extract data from VariantA
    public fun get_variant_a_num(e: &MyEnum): u8 {
        match e {
            MyEnum::VariantA { num } => *num,
            _ => 0,
        }
    }
}

// Dependency order: StructModule must be published before accessor functions are called


//# publish
module 0xBABE::Util {
    import 0xCAFE::StructModule;
    import 0xCAFE::EnumModule;

    // Import specific members with alias to test import syntax
    use StructModule::{get_value as gv, get_name as gn};
    use EnumModule::{get_variant_a_num};

    // Functions that utilize imported members
    public fun test_struct_access(s: &StructModule::MyStruct): (u64, vector<u8>) {
        (gv(s), gn(s))
    }

    public fun test_enum_variant(e: &EnumModule::MyEnum): u8 {
        get_variant_a_num(e)
    }

    // Runner for testing access permissions to struct fields
    public fun run_tests(): bool {
        let s = StructModule::MyStruct { value: 42, name: b"Test" };
        let e = EnumModule::MyEnum::VariantA { num: 255 };

        let val = test_struct_access(&s);
        let variant_num = test_enum_variant(&e);
        // Return true if values are correct (for test validation)
        val.0 == 42 && val.1 == b"Test" && variant_num == 255
    }
}

// Dependency order: Util depends on StructModule and EnumModule



//# run 0xBABE::Util::run_tests --signers 0xCAFE