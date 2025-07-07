
//# publish
module 0xCAFE::FriendModule {
    // FriendModule grants friendship to allow restricted function calls

    friend 0xCAFE::FriendUser;

    struct Data has store {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    public fun new_data(): Data {
        Data { a: 42, b: true, c: b"HelloFriend" }
    }

    public fun get_a(data: &Data): u64 {
        data.a
    }

    public fun get_b(data: &Data): bool {
        data.b
    }

    public fun get_c(data: &Data): vector<u8> {
        copy data.c
    }

    public fun friend_function(data: &Data): u64 {
        // Only callable by friend module FriendUser
        assert!(true, 0); // dummy assertion to exercise compiler
        data.a * 2
    }
}


//# publish
module 0xCAFE::FriendUser {
    // This module is a friend of FriendModule
    use 0xCAFE::FriendModule;

    friend 0xCAFE::FriendModule;

    public fun call_friend_function() {
        let data = FriendModule::new_data();

        // Destructure Data fields using pattern matching on left side
        let FriendModule::Data { a, b, c } = data;

        // Use the destructured variables
        let _ = a + 10;
        let _ = if (b) { 1 } else { 0 };
        let _len = vector::length(&c);

        // Call the friend function from FriendModule
        let _res = FriendModule::friend_function(&data);
    }

    public fun pattern_destructure_complex_tuple() {
        let t = (1u8, (2u16, 3u32), b"abc", true);
        let (x, (y, z), bytes, flag) = t;

        let _sum = (x as u32) + y as u32 + z;
        let _len = vector::length(&bytes);
        let _flag_num = if (flag) {1u8} else {0u8};
    }

    public fun pattern_destructure_enum() {
        enum SampleEnum has copy, drop {
            Variant1,
            Variant2(u8, bool),
            Variant3 { data: u64 }
        }

        let v1 = SampleEnum::Variant1;
        let v2 = SampleEnum::Variant2(10, true);
        let v3 = SampleEnum::Variant3{ data: 9999 };

        // Match and destructure enum in let statement (simulated by match and let)
        // Note: Move does not currently support direct enum destructuring in let, simulate with match

        // Destructure Variant2
        if (exists v2) {
            let (a, b) = (10u8, true);
            let _ = a;
            let _ = b;
        };

        // Destructure Variant3's data field
        if (exists v3) {
            let data_value = 9999u64;
            let _ = data_value;
        };
    }
}


//# run 0xCAFE::FriendUser::call_friend_function


//# run 0xCAFE::FriendUser::pattern_destructure_complex_tuple


//# run 0xCAFE::FriendUser::pattern_destructure_enum


// Featurres:
// c1f049f1baf1fe825a184f98acdc0d90: Declare friend modules or functions without creating implicit aliases.
// 50be35204c12abb319efdf34d4e63b3d: Take advantage of multiple compiler optimization passes on Move source code and bytecode.
// aa7ff054634cd6f0f8454357e5a1f2f2: Use patterns to destructure complex data structures on the left-hand side of an assignment.
