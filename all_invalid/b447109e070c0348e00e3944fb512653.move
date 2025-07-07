
//# publish
module 0xcafe::FriendModule {
    friend 0xcafe::CallerModule;

    const CONSTANT_FRIEND: u64 = 42;

    struct Data has copy, drop, store {
        value: u64
    }

    public fun get_constant(): u64 {
        CONSTANT_FRIEND
    }

    public fun create_data(val: u64): Data {
        Data { value: val }
    }

    public fun get_value(data: &Data): u64 {
        data.value
    }
}



//# publish
module 0xcafe::CallerModule {
    use 0xcafe::FriendModule;

    // CallerModule must be published second so FriendModule can refer to it

    public fun call_friend_constant(): u64 {
        FriendModule::get_constant()
    }

    public fun call_create_and_get(val: u64): u64 {
        let data = FriendModule::create_data(val);
        FriendModule::get_value(&data)
    }
}



//# run 0xcafe::CallerModule::call_friend_constant



//# run 0xcafe::CallerModule::call_create_and_get --args 123u64
