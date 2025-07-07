
//# publish
module 0xCAFE::FriendshipModule {
    use std::signer;

    // A module that manages friend modules for a specific account
    struct FriendList has key, store {
        friends: vector<address>,
    }

    public fun add_friend(account: &signer, friend_addr: address) {
        let list_ref = borrow_global_mut<FriendList>(signer::address_of(account));
        vector::push_back(&mut list_ref.friends, friend_addr);
    }

    public fun is_friend(account: &signer, addr: address): bool {
        let list_ref = borrow_global<FriendList>(signer::address_of(account));
        vector::contains(&list_ref.friends, addr)
    }

    public fun initialize(account: &signer) {
        move_to<FriendList>(account, FriendList { friends: vector::empty() });
    }
}



//# publish
module 0xCAFE::TargetModule {
    use std::signer;
    use 0xCAFE::FriendshipModule;

    // Define friendship (only modules listed in `allowed_friend_modules` can call this)
    const ALLOWED_FRIEND_MODULES: vector<address> = vector::empty();

    fun check_friendship(caller: address): bool {
        // For test purposes, we simulate passing the friendship check
        // (In real implementation, perhaps check against a stored list)
        true
    }

    // Function that only callable by a friend module
    public fun privileged_action(caller: address): bool {
        // Ensure caller is in the allowed friend modules
        // For this example, we check if caller is a friend of some account (simulate)
        // here, just check with the friendship module
        if (FriendshipModule::is_friend(&signer::borrow_signer(), caller)) {
            true
        } else {
            false
        }
    }
}



//# spec
spec {
    // Setup: Initialize accounts and modules
    init: {
        // Initialize two accounts: owner and friend
        // (simulated in transactional test)
    }

    // Define friendship
    friendship {
        from: 0xBEEF; // owner account
        to: 0xCAFE::TargetModule; // target module
    }

    // Test addition of friend and privilege call
    test_friendship_and_privileged_call: {
        // 1. Owner initializes friendship list
        // 2. Owner adds friend
        // 3. Call privilege function from friend address
        // 4. Verify the privilege success or failure according to friendship
    }
}



//# run 0xCAFE::FriendshipModule::initialize --signers 0xBEEF



//# run 0xCAFE::FriendshipModule::add_friend --signers 0xBEEF --args 0xDEADBEEF



//# run 0xCAFE::TargetModule::privileged_action --signers 0xDEADBEEF