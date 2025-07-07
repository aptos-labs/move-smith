
//# publish
module 0xCAFE::FriendModule {
    friend 0xCAFE::CallerModule; 

    const CONSTANT_FRIEND: u64 = 42;

    struct Data has copy, drop, store {
        value: u64
    }

    public fun get_constant(): u64 {
        CONSTANT_FRIEND
    }

    public fun create_data(val: u64): Data {
        let res = Data { value: val };
        res
    }

    public fun get_value(data: &Data): u64 {
        let v = data.value;
        v
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::FriendModule;

    public fun call_friend_constant(): u64 {
        let const_val = FriendModule::get_constant();
        const_val
    }

    public fun call_create_and_get(val: u64): u64 {
        let data = FriendModule::create_data(val);
        let v = FriendModule::get_value(&data);
        v
    }
}


//# run 0xCAFE::CallerModule::call_friend_constant


//# run 0xCAFE::CallerModule::call_create_and_get --args 123u64


// Featurres:
// 153adaf28b1f58790ebdd494582a0444: Declare module friends to specify which other modules have access.
// f37fe173f9d4b68fdd3a281e139f9295: Organize module members with proper syntax and attributes.
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
