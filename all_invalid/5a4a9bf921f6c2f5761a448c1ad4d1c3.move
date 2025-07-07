
//# publish
module 0xCAFE::AbilityTest {
    // Test 1: Create structs with various abilities to check enforcement
    struct CopyStruct has copy {
        a: u8
    }

    struct DropStruct has drop {
        b: u16
    }

    struct StoreStruct has store {
        c: u32
    }

    struct CopyDropStruct has copy, drop {
        d: u64
    }

    struct CopyStoreStruct has copy, store {
        e: address
    }

    struct FullAbilityStruct has copy, drop, store {
        f: bool
    }

    // Return instances to force struct usage and abilities checked
    public fun get_copy_struct(): CopyStruct {
        CopyStruct { a: 1 }
    }

    public fun get_drop_struct(): DropStruct {
        DropStruct { b: 2 }
    }

    public fun get_store_struct(): StoreStruct {
        StoreStruct { c: 3 }
    }

    public fun get_copy_drop_struct(): CopyDropStruct {
        CopyDropStruct { d: 4 }
    }

    public fun get_copy_store_struct(): CopyStoreStruct {
        CopyStoreStruct { e: @0xCAFE }
    }

    public fun get_full_ability_struct(): FullAbilityStruct {
        FullAbilityStruct { f: true }
    }
}


//# run 0xCAFE::AbilityTest::get_copy_struct


//# run 0xCAFE::AbilityTest::get_drop_struct


//# run 0xCAFE::AbilityTest::get_store_struct


//# run 0xCAFE::AbilityTest::get_copy_drop_struct


//# run 0xCAFE::AbilityTest::get_copy_store_struct


//# run 0xCAFE::AbilityTest::get_full_ability_struct


// Placeholder error types simulate unresolved or missing types in Move (Test 2)
struct __ErrorTypeUnresolved has copy, drop, store {}


//# publish
module 0xCAFE::ErrorPlaceholders {
    // Using placeholder error types in a struct's field
    struct ContainerWithError has store {
        // This field simulates an unresolved type error placeholder
        unresolved_field: __ErrorTypeUnresolved,
        valid_field: u8
    }

    // Public function to create a ContainerWithError instance
    public fun make_container(): ContainerWithError {
        let dummy_err = __ErrorTypeUnresolved {};
        ContainerWithError { unresolved_field: dummy_err, valid_field: 42 }
    }
}


//# run 0xCAFE::ErrorPlaceholders::make_container



//# publish
module 0xCAFE::PragmaTest {
    // Test 3: Use pragma directives with values being valid Move identifiers

    // A pragma with an identifier value
    pragma my_identifier_pragma "custom_identifier";

    // Another pragma whose value looks like an ability name (should not clash)
    pragma copy "copy";

    // Another pragma value equals to a reserved word (should be treated as string)
    pragma store "store";

    struct PStruct has store {
        value: u8
    }

    public fun new_pstruct(v: u8): PStruct {
        PStruct { value: v }
    }
}


//# run 0xCAFE::PragmaTest::new_pstruct --args 123u8


// Combined test (Test 4 & 5 & 6):
// Struct using error placeholders with explicit ability and pragma with identifier value

//# publish
module 0xCAFE::CombinedTest {
    pragma identifier_value "some_identifier";

    struct UnresolvedType has copy, drop {
        // simulate unresolved type field with error placeholder inside a struct with abilities
        error_field: __ErrorTypeUnresolved,
        flag: bool,
    }

    // Public function to create an instance with placeholders
    public fun new_unresolved(flag: bool): UnresolvedType {
        let dummy = __ErrorTypeUnresolved {};
        UnresolvedType { error_field: dummy, flag }
    }

    // Pragma to verify identifier value usage again (should not clash)
    pragma store "identifier";

}


//# run 0xCAFE::CombinedTest::new_unresolved --args true


// Featurres:
// a92129a9ab72b58d4326795e25b9bfcb: Use error placeholder types for unresolved types.
// 14750f6a2e264a5ffbfe13609da93522: Specify abilities for the struct, such as copy or drop, as part of the struct definition.
// ae83749d0886920342fdea6bdc4ba15f: Use pragma values that are identifiers in your Move code.
