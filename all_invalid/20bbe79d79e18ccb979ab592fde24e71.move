
//# publish
module 0xCAFE::TestCondAndFriend {
    use std::signer;

    // A struct to demonstrate public(friend) access
    struct FriendStruct has store {
        pub_x: u8,
        pub(friend) friend_y: u8,
        priv_z: u8,
    }

    // Constructor to create FriendStruct
    public fun new(pub_x: u8, friend_y: u8, priv_z: u8): FriendStruct {
        FriendStruct { pub_x, friend_y, priv_z }
    }

    // Public function to read pub_x
    public fun get_pub_x(fs: &FriendStruct): u8 {
        fs.pub_x
    }

    // friend function with access to friend_y
    public(friend) fun get_friend_y(fs: &FriendStruct): u8 {
        fs.friend_y
    }

    // Private function to read priv_z
    fun get_priv_z(fs: &FriendStruct): u8 {
        fs.priv_z
    }

    // Example function that uses if-else branching and returns u8
    public fun conditional_branching(x: u8): u8 {
        if (x < 10) {
            1
        } else if (x == 10) {
            2
        } else {
            3
        };
    }

    // Function to test calling public(friend) function from a friend module
    public fun friend_accessible(s: signer): u8 {
        let fs = new(10, 20, 30);
        // Call public(friend) function within this module (friend module)
        let friend_field = get_friend_y(&fs);
        friend_field
    }
}


//# publish
module 0xCAFE::FriendModule {
    use 0xCAFE::TestCondAndFriend;
    use std::signer;

    // This module is a friend of TestCondAndFriend, so it can access public(friend) items

    // Function that creates FriendStruct and reads friend_y field via public(friend) function
    public fun use_friend_field(s: signer): u8 {
        let fs = TestCondAndFriend::new(100, 200, 255);
        // Accessing public(friend) function get_friend_y from friend module - allowed
        let friend_value = TestCondAndFriend::get_friend_y(&fs);
        friend_value
    }

    // Trying to access priv_z would be illegal, so no function for that here
}


//# run 0xCAFE::TestCondAndFriend::conditional_branching --args 5u8


//# run 0xCAFE::TestCondAndFriend::conditional_branching --args 10u8


//# run 0xCAFE::TestCondAndFriend::conditional_branching --args 15u8


//# run 0xCAFE::TestCondAndFriend::friend_accessible --signers 0xABCD


//# run 0xCAFE::FriendModule::use_friend_field --signers 0xABCD


// Featurres:
// 7d54a29f13f619d919b362b132937185: Write conditional if-else expressions for control flow branching.
// acdaa6541ebd075c38b16fddc14104f1: Specify an item as publicly accessible to friends with 'public(friend)'.
// 8e1d377f1d048bdf169ed0c4e3223f63: Use identifiers in your Move code as names conforming to identifier syntax.
