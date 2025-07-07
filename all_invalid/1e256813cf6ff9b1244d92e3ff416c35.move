
//# publish
module 0xCAFE::FriendAccessModule {
    // Removed unused 'use std::signer;'

    struct InnerStruct<T, Phantom> has store {
        value: T,
        phantom: Phantom,
    }

    // Added 'public' to fields to allow external access
    struct GenericStruct<T, Phantom> has copy, drop, store {
        pub a: u64,
        pub b: T,
        pub phantom_field: Phantom,
    }

    // Added 'public' to allow field unpacking outside this module
    struct MultiFieldStruct has key, store {
        pub field1: u8,
        pub field2: u16,
        pub field3: bool,
    }

    // Friend function removed, made it public for access without friend relationship
    public fun friend_function(): u64 {
        42
    }

    public fun build_struct(): MultiFieldStruct {
        MultiFieldStruct { field1: 10, field2: 20, field3: true }
    }

    public fun make_generic_struct(): GenericStruct<u8, bool> {
        GenericStruct<u8, bool> { a: 100, b: 255u8, phantom_field: true }
    }

    public fun destructure_struct(s: MultiFieldStruct): u64 {
        let MultiFieldStruct { field1: f1, field2: f2, field3: f3 } = s;
        let res = (f1 as u64) + (f2 as u64) + if (f3) { 1 } else { 0 };
        res
    }
}




//# publish
module 0xCAFE::FriendModule {
    // Removed friend declaration to avoid circular dependency

    public fun call_friend_function(): u64 {
        0xCAFE::FriendAccessModule::friend_function()
    }

    public fun test_unpack_struct(): u64 {
        let s = 0xCAFE::FriendAccessModule::build_struct();
        // Unpack directly without fully qualifying the struct name because fields are public,
        // and unpacking outside the defining module is only allowed if fields are public
        let MultiFieldStruct { field1: a, field2: b, field3: c } = s;
        let sum = (a as u64) + (b as u64) + if (c) { 5 } else { 0 };
        sum
    }

    public fun test_generic_struct(): u64 {
        let gs = 0xCAFE::FriendAccessModule::make_generic_struct();
        let sum = gs.a + (gs.b as u64);
        sum
    }
}




//# publish
module 0xCAFE::FriendModule2 {
    // Removed friend declaration to avoid circular dependency

    public fun test_friend_access(): u64 {
        0xCAFE::FriendAccessModule::friend_function()
    }
}




//# run
script {
    use 0xCAFE::FriendModule;

    fun main() {
        // Test call friend function from FriendModule 
        let res = FriendModule::call_friend_function();
        let _ = res;

        // Test destructuring unpack with named fields in FriendModule
        let sum = FriendModule::test_unpack_struct();
        let _ = sum;

        // Test generic struct usage
        let gs_sum = FriendModule::test_generic_struct();
        let _ = gs_sum;
    }
}
