//# publish
module 0xCAFE::ClosureTest {
    use std::signer;

    // An inline function that takes a function value (closure) and calls it.
    inline fun call_with_two<F: copy + drop>(f: &F): u64
        where F: Fn() -> u64 {
        f()
    }

    public(friend) fun friend_function(): u64 {
        999
    }

    public fun runner(): u64 {
        // A local lambda closure that returns 42.
        let lambda = || { 42u64 };
        call_with_two(&lambda)
    }
}

//# run 0xCAFE::ClosureTest::runner

//# publish
module 0xCAFE::VariableInitTest {
    public fun categorize_locals(): (bool, bool, bool) {
        // 'no' initialization - declared, no initial value
        let mut x: u64;
        // 'maybe' initialization - initialized conditionally
        let mut y: u64;
        let cond = true;
        if (cond) {
            y = 7;
        } else {
            y = 8;
        }
        // 'yes' initialization - declared and initialized immediately
        let z: u64 = 3;

        // To prevent unused variable warning, just assign and return
        // x is uninitialized, can't be read otherwise error
        x = 10;

        (x != 0, y != 0, z != 0)
    }

    public fun runner(): (bool, bool, bool) {
        categorize_locals()
    }
}

//# run 0xCAFE::VariableInitTest::runner

//# publish
module 0xCAFE::FriendTest {
    friend 0xCAFE::ClosureTest;
    
    public(friend) fun friend_only_function(): u64 {
        2024
    }

    public fun runner(): u64 {
        // Call friend function from friend module
        // ClosureTest is a friend so can access 'public(friend)' there
        let v1 = 0xCAFE::ClosureTest::friend_function();
        let v2 = friend_only_function();
        v1 + v2
    }
}

//# run 0xCAFE::FriendTest::runner

// Featurres:
// ce0b87fbc06882d26f1bfd9a5b30df50: Test that an inline function can accept a function value (lambda/closure) as an argument and invoke it correctly.
// e737c436af184ab5cb814c1263acd1ea: Categorize local variables as 'no', 'maybe', or 'yes' initialized based on their initialization status.
// 0496ae800bd35e891a22b97a0664b057: Use 'public(friend)' functions to allow controlled module access via friend declarations.
