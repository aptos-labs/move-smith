//# publish
module 0xCAFE::FriendModule {
    friend 0xCAFE::MainModule;

    public fun friend_function(): u64 {
        10
    }
}

//# publish
module 0xCAFE::MainModule {
    use 0xCAFE::FriendModule;

    public fun nested_inline_add(x: u64, y: u64): u64 {
        // deeply nested inline function calls
        // we inline add_two calls multiple times
        fun add_two(a: u64): u64 {
            a + 2
        }
        // inline usage nested
        add_two(add_two(add_two(x + y)))
    }

    public fun multiple_let_assignments(): u64 {
        let mut a = 5;
        a = a + 1;
        let b = a + 3;
        let mut c = b;
        c = c + a;
        c
    }

    public fun call_friend_function(): u64 {
        FriendModule::friend_function()
    }

    public fun runner(): u64 {
        let nested = nested_inline_add(1, 2);
        let assigned = multiple_let_assignments();
        let friend_val = call_friend_function();
        nested + assigned + friend_val
    }
}

//# run 0xCAFE::MainModule::runner
//# run 0xCAFE::FriendModule::friend_function
//# run 0xCAFE::MainModule::nested_inline_add --args 3u64 4u64
//# run 0xCAFE::MainModule::multiple_let_assignments
//# run 0xCAFE::MainModule::call_friend_function

// Featurres:
// a84005e43ace4dad7ab9718cdc598d05: Declare a friend module using the 'friend' keyword in Move
// fff15ad0728ac26c542392e9e394a7f9: Test that deeply nested inline function calls are correctly inlined and optimized to produce the correct result.
// 247e1a93e014e776c9c22ce86e785f08: Test that multiple assignments to a variable using "let" and subsequent usage in expressions within a function work correctly.
