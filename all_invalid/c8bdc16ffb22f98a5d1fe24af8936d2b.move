
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Test defining functions within a module
    public fun test_function(x: u64): u64 {
        x + 42
    }

    // Mark a type parameter as phantom in struct
    struct PhantomStruct<T> has copy, drop, store {
        data: u64,
        phantom: phantom<T>,
    }

    // Define enum in module and access only within the module
    enum TestEnum has copy, drop {
        VariantA,
        VariantB(u8, u8),
        VariantC { a: bool }
    }

    // Access fields of structs and enum variants only within the module
    public fun create_phantom_struct(): PhantomStruct<u32> {
        PhantomStruct { data: 100, phantom: phantom::<u32>() }
    }

    public fun match_enum(e: TestEnum): u8 {
        match e {
            TestEnum::VariantA => 0,
            TestEnum::VariantB(x, y) => x + y,
            TestEnum::VariantC { a } => if a { 1 } else { 0 },
        }
    }

    // Helper function to create enum
    public fun create_enum_a(): TestEnum {
        TestEnum::VariantA
    }

    // Helper function with enum VariantB
    public fun create_enum_b(): TestEnum {
        TestEnum::VariantB(5, 10)
    }

    // Helper function with enum VariantC
    public fun create_enum_c(): TestEnum {
        TestEnum::VariantC { a: true }
    }
}


//# run 0xCAFE::TestModule::test_function --args 1234u64

//# run 0xCAFE::TestModule::create_phantom_struct

//# run 0xCAFE::TestModule::match_enum --args 0xCAFE::TestModule::create_enum_a

//# run 0xCAFE::TestModule::match_enum --args 0xCAFE::TestModule::create_enum_b

//# run 0xCAFE::TestModule::match_enum --args 0xCAFE::TestModule::create_enum_c

// Featurres:
// 01ae0dee98f6a792638514ce50c68442: Define functions within a module.
// d29c9d90bf170cbd1e3673cd3413f617: Mark type parameters as phantom in Move struct definitions
// 0d8ecdd2f388687882492a88acc316ea: Access fields of structs and enum variants only within the module that defines them, unless the module is explicitly permitted.
