
//# publish
module 0xCAFE::AbilityTest {
    use std::vector;
    use std::option;

    // Declare abilities for a struct
    struct AbilityStruct has copy, drop, store {
        flag: bool
    }

    // Declare enum variants with abilities
    enum AbilityEnum has copy, drop {
        V1,
        V2(u8, u8),
        V3 { b: bool }
    }

    // Function to test abilities declaration and usage
    public fun test_ability_declaration() {
        // Create AbilityStruct with abilities
        let s = AbilityStruct { flag: true };
        let s_copy = s; // abilities allow copying
        let s_borrow = &s;

        // Check if abilities are present by attempting to drop or move
        // These actions are compile-time checks in Move, so here we just use them
        let _ = s_copy;

        // Create enum Variant with abilities
        let e1 = AbilityEnum::V1;
        let e2 = AbilityEnum::V2(10, 20);
        let e3 = AbilityEnum::V3 { b: false };

        // Match to utilize variants
        let result = match e2 {
            AbilityEnum::V1 => 1,
            AbilityEnum::V2(a, b) => a + b,
            AbilityEnum::V3 { b } => if (b) { 2 } else { 3 },
        }; // Added semicolon here to terminate the match expression

        // Use result to avoid dead code elimination
        assert!(result >= 0, 999);
    }

    // Function to check if an AbilitySet (simulate with option::some or none) is empty
    public fun check_ability_set_empty() {
        let abilities: option::Option<AbilityStruct> = option::none<AbilityStruct>();
        let is_empty = match abilities {
            option::None => true,
            option::Some(_) => false,
        };
        assert!(is_empty, 1000);
        let abilities2: option::Option<AbilityStruct> = option::some(AbilityStruct { flag: false });
        let is_empty2 = match abilities2 {
            option::None => true,
            option::Some(_) => false,
        };
        assert!(!is_empty2, 1001);
    }

    // Function to utilize extension options (simulate with a dummy extension)
    public fun env_extension_behavior() {
        // Simulate extension behavior: custom logic based on environment
        // Since Move does not have native extension options, simulate with constants
        const EXTENSION_ENABLED: bool = true;
        if (EXTENSION_ENABLED) {
            // perform custom behavior
            let val = 42u64;
            assert!(val == 42, 1002);
        } else {
            // fallback behavior
            let val = 0u64;
            assert!(val == 0, 1003);
        }; // Added semicolon here to terminate the if statement
    }
}



//# run 0xCAFE::AbilityTest::test_ability_declaration



//# run 0xCAFE::AbilityTest::check_ability_set_empty



//# run 0xCAFE::AbilityTest::env_extension_behavior