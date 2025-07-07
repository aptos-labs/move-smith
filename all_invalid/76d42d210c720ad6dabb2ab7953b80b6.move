// This transactional test demonstrates:
// 1. Using 'no' keyword to mark unreachable code segments
// 2. Declaring friend functions and calling them across friend modules
// 3. Using decimal integer literals with underscore separators

// Address used: 0xCAFE, 0xBEEF

//# publish
module 0xCAFE::NoFriend {

    // A simple struct to hold a numeric value
    struct ValueHolder has copy, drop, store, key {
        val: u64,
    }

    // Public function marks a branch that is definitely unreachable using 'no'
    public fun unreachable_branch(x: u8): u64 {
        if (x > 0) {
            42u64
        } else {
            no;  // 'no' indicates unreachable code here
            0u64
        }
    }

    // Friend function visible only to 0xBEEF::FriendCaller
    friend fun friend_only_function(): u64 {
        // Return a large literal with underscores for testing
        1_000_000_000u64
    }

    // A runner function that calls the unreachable_branch with x=0 to show it works normally
    public fun runner(): u64 {
        unreachable_branch(1)
    }
}
//# run 0xCAFE::NoFriend::runner

//# publish
module 0xBEEF::FriendCaller {

    use 0xCAFE::NoFriend;

    // Public function calling the friend function defined in 0xCAFE::NoFriend
    public fun call_friend(): u64 {
        // This call is allowed because FriendCaller is declared as friend
        NoFriend::friend_only_function()
    }
}
//# run 0xBEEF::FriendCaller::call_friend

//# run
script {
    use 0xCAFE::NoFriend;
    use 0xBEEF::FriendCaller;

    fun main() {
        // Call runner in NoFriend module, expects 42u64 returned
        let val1 = NoFriend::runner();
        // val1 is 42u64

        // Call friend-only function through FriendCaller
        let val2 = FriendCaller::call_friend();
        // val2 is 1_000_000_000u64 with underscore separators in literal

        // Just to avoid unused warnings:
        let _ = val1;
        let _ = val2;
    }
}

// Featurres:
// 0f969730f1ad33e58b8fdc7180c14a97: Use 'no' as an indication that a code segment is definitely not reachable.
// 3eb02b2b9cf5da4359e8c4e6eb736e2f: Declare functions with friend visibility that can be called from specified friend modules.
// b60113de45fdd90b8bb0fedae446cf1f: Write decimal integer literals using digits and underscores as separators
