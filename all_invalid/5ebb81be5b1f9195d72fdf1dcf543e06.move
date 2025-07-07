
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

    // Function to declare abilities with 'has' keyword
    public fun declare_abilities() {
        struct ExtendedStruct has copy, drop, store {
            x: u8,
            y: u8,
        }

        // Declare abilities with multiple traits
        struct MultiAbilityStruct has copy, drop, store, key {}
    }

    // Test contextual usage of abilities
    public fun abilities_usage() {
        let s = ExtendedStruct { x: 1, y: 2 };
        let _ = move_to<ExtendedStruct>(&signer::create_signer("0x1"), s);
        let _ = borrow_global<ExtendedStruct>(signer::address_of(&signer::create_signer("0x1")));
    }

    // Warning: duplicated use statement
    public fun duplicate_use_statement() {
        use 0xCAFE::MyModule;
        // expect warning: duplicate import of '0xCAFE::MyModule'
    }

    // Function to cause a compilation error due to invalid ability keyword
    public fun invalid_ability_keyword() {
        struct BadAbilityStruct has invalidAbility {
            x: u8,
        };
        // expect compile error: unexpected ability 'invalidAbility'
    }

    // Function with correct use and abilities declarations and a call to functions
    public fun run_tests() {
        // Proper use statements and function calls
        let _ = store_at_signer_address(signer::create_signer("0xFACE"), 5u8, 6u8);
        let vals = inspect_value(signer::create_signer("0xFACE"));
        let _ = update_value(signer::create_signer("0xFACE"), 7u8, 8u8);
        ()
    }
}


//# run 0xBADD::DiagnosticsTest::test_invalid_use --signers 0x1234


//# run 0xBADD::DiagnosticsTest::test_unused_import


//# run 0xBADD::DiagnosticsTest::declare_abilities


//# run 0xBADD::DiagnosticsTest::abilities_usage --signers 0x5678


//# run 0xBADD::DiagnosticsTest::duplicate_use_statement


//# run 0xBADD::DiagnosticsTest::invalid_ability_keyword


//# run 0xBADD::DiagnosticsTest::run_tests --signers 0xFACE


// Featurres:
// 4ca8ffd29af511d66e3a78ca3cca731a: Declare use statements to import modules or their members in Move code
// a75be28b42531309e9e48e4eb98f1c02: Receive diagnostic error and warning messages with accurate source locations during Move compilation
// 2982eb479c9865ac9028434fdbfcae34: Declare abilities with a 'has' keyword followed by one or more abilities separated by commas.
