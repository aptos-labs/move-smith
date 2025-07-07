
//# publish
module 0xCAFE::AddModule {
    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            sum
        } else {
            42
        };
        100
    }

    // An inline function returning tuple
    public inline fun inline_adder(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun test_nested_calls(a: u8, b: u8): u8 {
        let (sum, product) = AddModule::inline_adder(a, b);
        assert!(product > 0, 900);
        sum
    }
}


//# publish
module 0xCAFE::UninitCheck {
    // Test for variable declared before 'if' but return in one branch that disables initialization recognition
    public fun check_var(x: u8, cond: bool): u8 {
        let res = 0u8;
        if (cond) {
            return 42;
        } else {
            res = x;
        };
        res
    }
}


//# publish
module 0xCAFE::FriendModule {
    friend 0xCAFE::CallerModule;

    public(friend) fun friend_only_function(): u8 {
        77
    }
}


//# publish
module 0xCAFE::UseFriendInCaller {
    use 0xCAFE::FriendModule;
    use 0xCAFE::CallerModule;

    // Should access friend_only_function from FriendModule
    public fun call_friend(): u8 {
        FriendModule::friend_only_function()
    }
}


//# publish
module 0xCAFE::InvalidMemberAccess {
    // A dummy field to try invalid member access with
    const MY_CONST: u8 = 5;

    public fun test_invalid_member_access(): u8 {
        // The below line must generate compile error if uncommented:
        // let _ = InvalidMemberAccess.MY_CONST;
        1
    }
}


//# run 0xCAFE::AddModule::add_two --args 4u8 9u8


//# run 0xCAFE::CallerModule::test_nested_calls --args 3u8 7u8


//# run 0xCAFE::UninitCheck::check_var --args 123u8 true


//# run 0xCAFE::UninitCheck::check_var --args 123u8 false


//# run 0xCAFE::UseFriendInCaller::call_friend


//# run 0xCAFE::InvalidMemberAccess::test_invalid_member_access


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9215ae1df667395735358a83241850e3: Test that variables declared before an if-else statement are correctly recognized as potentially uninitialized if a return occurs in one branch.
// 0496ae800bd35e891a22b97a0664b057: Use 'public(friend)' functions to allow controlled module access via friend declarations.
// 616f16896c7e0fdcbc2027f751f2c465: Receive errors when trying to use member accesses (like module fields or functions) in places where only a module identifier is expected.
