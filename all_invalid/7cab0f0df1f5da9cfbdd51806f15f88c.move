
//# publish
module 0xCAFE::AccessControlTest {
    const CONST_VAL: u64 = 0xDEADBEEF;

    // A package-visible constant function
    public(package) fun get_const(): u64 {
        CONST_VAL
    }

    // A friend-access function: only this module or its friends can call
    public(friend) fun friend_only_function(): u64 {
        42
    }

    // A public function with no friend modifier to check public access
    public fun public_function(): u64 {
        100
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AccessControlTest;

    public fun call_get_const(): u64 {
        AccessControlTest::get_const()
    }

    public fun call_friend_function(): u64 {
        AccessControlTest::friend_only_function()
    }

    public fun call_public_function(): u64 {
        AccessControlTest::public_function()
    }
}



//# run 0xCAFE::CallerModule::call_get_const


//# run 0xCAFE::CallerModule::call_friend_function


//# run 0xCAFE::CallerModule::call_public_function
