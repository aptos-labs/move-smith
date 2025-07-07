//# publish
module 0xCAFE::ModuleWithFriend {
    friend 0xCAFE::FriendModule;

    struct FriendData has copy, drop, store {
        value: u64,
    }

    // Only friend module can create friend data
    friend fun create_friend_data(v: u64): FriendData {
        FriendData { value: v }
    }

    fun get_value(fd: &FriendData): u64 {
        fd.value
    }
}

//# publish
module 0xCAFE::FriendModule {
    use std::signer;
    use 0xCAFE::ModuleWithFriend;

    struct Wrapper has store {
        data: ModuleWithFriend::FriendData,
    }

    /// Create friend data and store it under signer address
    public fun store_data(s: signer, v: u64) {
        let fd = ModuleWithFriend::create_friend_data(v);
        let w = Wrapper { data: fd };
        move_to<Wrapper>(&s, w);
    }

    /// Read the friend data value
    public fun read_data(s: signer): u64 {
        let w_ref: &Wrapper = borrow_global<Wrapper>(signer::address_of(&s));
        ModuleWithFriend::get_value(&w_ref.data)
    }
}

//# run 0xCAFE::FriendModule::store_data --signers 0xBEEF --args 123u64

//# run 0xCAFE::FriendModule::read_data --signers 0xBEEF

// Featurres:
// 73265337ad08f8e478c741080579f48a: Receive and process diagnostic messages generated during Move code compilation
// 4a605b4da4cb9f0458b0e2a70aa9f3d1: Abort compilation if bytecode verification errors are found.
// 153adaf28b1f58790ebdd494582a0444: Declare module friends to specify which other modules have access.
