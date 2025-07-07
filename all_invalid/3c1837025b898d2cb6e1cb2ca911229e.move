
//# publish
module 0xCAFE::FriendA {
    // Declare FriendB as a friend to access internal functions and data
    // Note: Explicit friend relationships might be via resource or function visibility marks
    // but in Move, "friend" is typically simulated via pub(pub(friend))
    use std::vector;

    // Internal struct with pub(pub(friend))
    struct SecretStruct has store, key {
        secret_value: u64,
    }

    // Internal function only accessible to friend modules
    public(fun internal_secret_access(): u64) {
        42
    }
}


//# publish
module 0xCAFE::FriendB {
    use 0xCAFE::FriendA;

    // Access internal function of FriendA as a friend
    public(fun call_friend_secret(): u64) {
        FriendA::internal_secret_access()
    }
}


//# publish
module 0xCAFE::NonFriend {
    // Attempt to access internal function of FriendA (should fail if not friend)
    public(fun attempt_access(): u64) {
        // Should not be able to call FriendA::internal_secret_access()
        // but for the test, we just leave it commented or simulate attempt
        // to illustrate expected access restriction
        // FriendA::internal_secret_access() // This line should cause compilation error
        0
    }
}

// Enum with multiple variants, including nested enum, testing pattern matching
// Also involving type parameters T0 and T1
// Enums defined at module top level to test pattern matching
// and access control


//# publish
module 0xCAFE::EnumTest {
    // Enums with multiple variants, including nested enum and generics

    // Enum with variants
    enum VariantEnum<T0, T1> has copy, drop {
        V1,
        V2(u64, T0),
        V3 {
            nested: NestedEnum<T1>,
        }
    }

    // Nested enum inside VariantEnum
    enum NestedEnum<T1> has copy, drop {
        N1,
        N2,
        N3 {
            value: T1,
        }
    }

    // A function to pattern match over VariantEnum with various variants
    public fun match_variant<T0: copy, T1: copy>(val: VariantEnum<T0, T1>): u8 {
        match (val) {
            VariantEnum::V1 => 1,
            VariantEnum::V2(_x, _t0) => 2,
            VariantEnum::V3 { nested } => match (nested) {
                NestedEnum::N1 => 3,
                NestedEnum::N2 => 4,
                NestedEnum::N3 { value } => 5,
            },
        }
    }
}


//# publish
module 0xCAFE::GenericStructs {
    // Generic struct with type parameters
    struct Container<T> has store, drop {
        item: T,
        id: u64,
    }

    // Function to instantiate generic structs with T0, T1
    public fun create_container_with_T0<T0: copy + drop>(item: T0, id: u64): Container<T0> {
        Container { item, id }
    }

    public fun create_container_with_T1<T1: copy + drop>(item: T1, id: u64): Container<T1> {
        Container { item, id }
    }

    // Function to pattern match on VariantEnum with T0 and T1 types
    public fun process_enum<T0: copy + drop, T1: copy + drop>(val: VariantEnum<T0, T1>): u8 {
        match (val) {
            VariantEnum::V1 => 10,
            VariantEnum::V2(_x, _t0) => 20,
            VariantEnum::V3 { nested } => match (nested) {
                NestedEnum::N1 => 30,
                NestedEnum::N2 => 40,
                NestedEnum::N3 { value } => 50,
            },
        }
    }
}


//# run 0xCAFE::EnumTest::match_variant --args (VariantEnum::V1::<copy, copy>) (no args), expect 1

//# run 0xCAFE::EnumTest::match_variant --args (VariantEnum::V2::<copy, copy>(5, 100u64)), expect 2

//# run 0xCAFE::EnumTest::match_variant --args (VariantEnum::V3 { nested: NestedEnum::N1 }), expect 3

//# run 0xCAFE::EnumTest::match_variant --args (VariantEnum::V3 { nested: NestedEnum::N3 { value: 42 } }), expect 5


//# run 0xCAFE::GenericStructs::create_container_with_T0 --args 123u64 1 --signers 0xBEEF

//# run 0xCAFE::GenericStructs::create_container_with_T1 --args 456u64 2 --signers 0xBEEF


//# run 0xCAFE::GenericStructs::process_enum --args (VariantEnum::V1 <copy, copy>)

//# run 0xCAFE::GenericStructs::process_enum --args (VariantEnum::V2::<copy, copy>(7, 200u64))

//# run 0xCAFE::GenericStructs::process_enum --args (VariantEnum::V3 { nested: NestedEnum::N2 })

//# run 0xCAFE::GenericStructs::process_enum --args (VariantEnum::V3 { nested: NestedEnum::N3 { value: 88 } })

// Additional tests to verify access control and interaction

//# run 0xCAFE::FriendA::call_friend_secret --signers 0xBEEF

//# run 0xCAFE::NonFriend::attempt_access // the call should fail if attempts are made to access internal functions of FriendA


// Featurres:
// 8309f9b54ec16331b5e022c70df0f0e6: Declare 'friend' relationships between modules to provide special access.
// eec4b5db199960ba48877cef2c2f302e: Declare enums with multiple variants.
// 6f7233f3399e89f976dbf1b51e09c3a3: Define type parameters with the naming pattern T followed by their index number, such as T0, T1, etc.
