
//# publish
module 0xCAFE::TypeAndAbilityTest {
    use std::vector;

    // Declare a struct with conflicting abilities at different points
    struct ConflictingAbilitiesStruct has copy, drop, store, key {}

    // Enum with variant list before abilities (which may lead to syntax error if used improperly)
    // For testing, abilities are declared outside the enum, but include a variant with a guard.
    enum TestEnum has copy, drop {
        Variant1,
        Variant2(u64, u64),
        Variant3 { flag: bool }
    }

    // Function demonstrating explicit type for bound variable
    public fun explicit_type_bound_var() {
        let x: u8 = 10;
        let y: u16 = 20;
        // Using explicit type in let binding
        let z: u32 = (x as u32) + (y as u32);
        z
    }

    // Function demonstrating conflicting abilities in a struct (test for syntax error or handling)
    // abilities are declared in the struct but purposely duplicated or conflicting for test
    struct ConflictingStruct has copy, drop, store, key {
        value: u8
    }

    // Function that matches enum variants with optional guard condition
    public fun match_with_guard(e: TestEnum): u8 {
        match e {
            TestEnum::Variant1 => 1,
            TestEnum::Variant2(x, y) if x + y > 100 => 2,
            TestEnum::Variant2(x, y) => 3,
            TestEnum::Variant3 { flag } if flag => 4,
            TestEnum::Variant3 { flag } => 5,
        }
    }
}


//# run 0xCAFE::TypeAndAbilityTest::explicit_type_bound_var


//# run 0xCAFE::TypeAndAbilityTest::match_with_guard --args 0u8

// Featurres:
// da88cb0b71f84cf619ddcb78a651153f: Specify an optional type for a bound variable to explicitly declare its type.
// c919a1cd2026b69b6a3d9484a5406c6f: Declare conflicting abilities either before or after the variant list, but not both, to avoid syntax errors.
// d5a0a8baa349210b30e6d36b0e91eda3: Add an optional 'if' guard expression to a match arm for conditional matching.
