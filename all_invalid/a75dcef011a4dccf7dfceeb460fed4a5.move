
//# publish
module 0xCAFE::FriendAccessModule {
    use std::signer;

    // Declare friend modules, only these friends can access friend-only functions
    friend 0xCAFE::FriendModule;
    friend 0xCAFE::FriendModule2;

    struct InnerStruct<T, Phantom> has store {
        value: T,
        phantom: Phantom,
    }

    // Generic struct with optional phantom type parameter
    struct GenericStruct<T, Phantom> has copy, drop, store {
        a: u64,
        b: T,
        phantom_field: Phantom,
    }

    // Struct with multiple fields to be destructured
    struct MultiFieldStruct has key, store {
        field1: u8,
        field2: u16,
        field3: bool,
    }

    // Friend-only function
    friend fun friend_function() : u64 {
        42
    }

    // Public function returning struct to test unpacking in caller
    public fun build_struct(): MultiFieldStruct {
        MultiFieldStruct {field1: 10, field2: 20, field3: true}
    }

    // Function returning generic struct with phantom field used as unit ()
    public fun make_generic_struct(): GenericStruct<u8, ()> {
        GenericStruct<u8, ()>{a: 100, b: 255u8, phantom_field: ()}
    }

    // Function using named unpacking pattern to destructure MultiFieldStruct fields
    public fun destructure_struct(s: MultiFieldStruct): u64 {
        let MultiFieldStruct {field1: f1, field2: f2, field3: f3} = s;
        let res = (f1 as u64) + (f2 as u64) + if (f3) {1} else {0};
        res
    }
}


//# publish
module 0xCAFE::FriendModule {
    use std::signer;
    friend 0xCAFE::FriendAccessModule;

    // Call friend function inside FriendAccessModule
    public fun call_friend_function(): u64 {
        0xCAFE::FriendAccessModule::friend_function()
    }

    // Call build_struct and unpack fields using named pattern
    public fun test_unpack_struct(): u64 {
        let s = 0xCAFE::FriendAccessModule::build_struct();
        let 0xCAFE::FriendAccessModule::MultiFieldStruct {field1: a, field2: b, field3: c} = s;
        let sum = (a as u64) + (b as u64) + if (c) {5} else {0};
        sum
    }

    // Call make_generic_struct and access fields
    public fun test_generic_struct(): u64 {
        let gs = 0xCAFE::FriendAccessModule::make_generic_struct();
        let sum = gs.a + (gs.b as u64);
        sum
    }
}


//# publish
module 0xCAFE::FriendModule2 {
    friend 0xCAFE::FriendAccessModule;

    public fun test_friend_access(): u64 {
        0xCAFE::FriendAccessModule::friend_function()
    }
}


//# run
script {
    use std::signer;
    use 0xCAFE::FriendModule;

    fun main(s: signer) {
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


// Featurres:
// 153adaf28b1f58790ebdd494582a0444: Declare module friends to specify which other modules have access.
// d1e12a69a06c90294a886d08ffb76ad7: Define a generic struct with type parameters that include optional phantom parameters.
// 19e7b9eb0c2af9697d14c36ad6ae53a4: Bind multiple fields of a struct or schema using named unpacking patterns in bindings and destructuring assignments.
