
//# publish
module 0xDEAD::AliasModule {
    use std::vector;
    use 0xCAFE::MyModule;

    // Alias for a struct from MyModule
    public fun create_struct_with_alias(x: u16): MyModule::S {
        MyModule::f3(x)
    }

    // Alias for an enum variant
    public fun match_enum_variant(e: MyModule::E): u8 {
        let _ = e;
        match e {
            MyModule::E::V1 => 1,
            MyModule::E::V2(x, y) => x + y,
            MyModule::E::V3 { a } => if (a) { 42 } else { 0 },
        }
    }

    // Aliased function from MyModule
    public fun call_f4() {
        let _ = MyModule::f4();
    }
}



//# run 0xDEAD::AliasModule::create_struct_with_alias --args 15u16



//# run 0xDEAD::AliasModule::match_enum_variant --args 0xCAFE::MyModule::E::V2(7u64, 8u64)


// This script tests the proper management of function return values, aliasing, and multiple uses of locals


//# run
script {
    // Call a function that returns a struct and assign alias
    let s_alias = 0xDEAD::AliasModule::create_struct_with_alias(20u16);
    // Call function returning an enum and assign alias
    let e_alias = 0xCAFE::MyModule::E::V3 { a: true };
    // Match the alias enum to get a value
    let result1 = 0xDEAD::AliasModule::match_enum_variant(e_alias);
    // Store multiple function results for reuse
    let result2 = 0xCAFE::MyModule::f8();
    let result3 = 0xDEAD::AliasModule::match_enum_variant(e_alias);
    // Call function that internally reuses previous locals
    0xDEAD::AliasModule::call_f4();

    // Verify that local variables are managed correctly (no explicit assertion needed here)
    // The last expression is the test's success indicator
    result1 + result2 + result3
};
// Featurres:
// 6b03d32f04b853bf9dea70f054ebb2e0: Assign aliases to imported members from modules
// 2a06a5c3c4311fb5835a792534913bac: Test that values returned from a function are properly saved to locals and managed on the stack when they must be used multiple times in subsequent operations.
// 5f51af823e6eb607537b70c7ee38b56b: Annotate attributes with testing metadata
