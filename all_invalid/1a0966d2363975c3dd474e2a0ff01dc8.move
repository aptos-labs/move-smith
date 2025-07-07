
//# publish
module 0xCAFE::EnumPatternMatching {
    use std::vector;

    // Define an enum with multiple variants, including nested structs and tuples
    enum MyEnum has copy, drop {
        VariantTuple(u64, u64),
        VariantStruct { a: bool, b: u32 },
        VariantNested(Box<MyEnum>),
        VariantEmpty,
    }

    // Function to test pattern matching and destructuring on enum variants
    public fun test_match(e: MyEnum): u64 {
        match (e) {
            MyEnum::VariantTuple(x, y) => x + y,
            MyEnum::VariantStruct { a: true, b } => b as u64,
            MyEnum::VariantStruct { a: false, b } => b as u64 * 2,
            MyEnum::VariantNested(inner) => {
                // recursively match the inner
                match (*inner) {
                    MyEnum::VariantEmpty => 0,
                    _ => 42,
                }
            }
            MyEnum::VariantEmpty => 999,
        }
    }

    // Function to test wildcards and binding syntax
    public fun test_bindings(e: MyEnum): u64 {
        match (e) {
            MyEnum::VariantTuple(x, _) => x,
            MyEnum::VariantStruct { a: _, b } => b as u64,
            MyEnum::VariantNested(_) => 1,
            MyEnum::VariantEmpty => 0,
        }
    }
}

// To check deprecation, define a deprecated module (simulate with comment, as Move doesn't have deprecation attribute)
// However, for the test, create a module with a dummy deprecation marker in comment


//# publish
module 0xCAFE::DeprecatedModule {
    // This module is deprecated
    public fun dummy() {}
}



//# run 0xCAFE::EnumPatternMatching::test_match --args u64::VariantTuple(10, 20) --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_match --args MyEnum::VariantStruct { a: true, b: 5 } --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_match --args MyEnum::VariantStruct { a: false, b: 7 } --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_match --args MyEnum::VariantNested(Box::new(MyEnum::VariantEmpty)) --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_match --args MyEnum::VariantEmpty --type-args MyEnum



//# run 0xCAFE::EnumPatternMatching::test_bindings --args MyEnum::VariantTuple(42, 100) --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_bindings --args MyEnum::VariantStruct { a: false, b: 55 } --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_bindings --args MyEnum::VariantNested(Box::new(MyEnum::VariantEmpty)) --type-args MyEnum


//# run 0xCAFE::EnumPatternMatching::test_bindings --args MyEnum::VariantEmpty --type-args MyEnum

// Test module marked for deprecation (simulate - no runtime effect, but included as part of the test)


//# run 0xCAFE::DeprecatedModule::dummy --type-args ()
