//# publish
module 0xBADD::DiagnosticsTest {
    // Testing use statements: Should compile successfully
    use std::vector;
    use 0xCAFE::MyModule;
    use 0xCAFE::StorageUsage::{store_at_signer_address, inspect_value, update_value};

    // Testing abilities: Declare a struct with multiple abilities
    struct AbleStruct has copy, drop, store, key {
        a: u8,
        b: u16,
    }

    // Function to trigger diagnostic error: invalid use statement (non-existent module member)
    public fun test_invalid_use() {
        use 0xCAFE::NonExistentModule::NonExist;
        // expect compile-time error: module 'NonExistentModule' does not contain 'NonExist'
    }

    // Function to trigger diagnostic warning: unused import
    public fun test_unused_import() {
        // 'vector' is imported but not used
        // expect warning: unused import of 'vector'
    }

    // Function to declare abilities with 'has' keyword (must be inside a struct)
    public fun declare_abilities() {
        // Corrected: defining structs with abilities
        // Declare abilities with multiple traits
        struct ExtendedStruct has copy, drop, store {
            x: u8,
            y: u8,
        }

        // Additional struct with multiple abilities
        struct MultiAbilityStruct has copy, drop, store, key {}
    }

    // Test contextual usage of abilities
    public fun abilities_usage() {
        let s = ExtendedStruct { x: 1, y: 2 };
        // Create a signer
        let signer = signer::create_signer("0x1");
        // Move 's' to signer account
        move_to<ExtendedStruct>(&signer, s);
        // Borrow global (assuming the account exists)
        borrow_global<ExtendedStruct>(signer::address_of(&signer));
    }

    // Warning: duplicated use statement
    public fun duplicate_use_statement() {
        use 0xCAFE::MyModule;
        // expect warning: duplicate import of '0xCAFE::MyModule'
    }

    // Function to cause a compilation error due to invalid ability keyword
    public fun invalid_ability_keyword() {
        // Incorrect ability keyword 'invalidAbility' which isn't recognized
        struct BadAbilityStruct has invalidAbility {
            x: u8,
        };
        // expect compile error: unexpected ability 'invalidAbility'
    }

    // Function with correct use and abilities declarations and a call to functions
    public fun run_tests() {
        // Proper use statements and function calls
        let signer1 = signer::create_signer("0xFACE");
        let _ = store_at_signer_address(&signer1, 5u8, 6u8);
        let vals = inspect_value(signer::create_signer("0xFACE")); // creating new signer again
        let _ = update_value(&signer1, 7u8, 8u8);
        ()
    }
}
