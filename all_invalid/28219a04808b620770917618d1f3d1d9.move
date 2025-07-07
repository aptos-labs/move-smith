
//# publish
module 0xCAFE::FriendA {
    use std::signer;
    use std::move_to;
    use std::borrow_global;

    struct Data has store, key {
        val: u64
    }

    public fun create_data(account: signer, val: u64) {
        let data = Data { val };
        move_to<Data>(&account, data);
    }

    // FriendB declared as friend of this module
    friend 0xCAFE::FriendB;

    public fun read_data(account: signer): u64 acquires Data {
        let addr = signer::address_of(&account);
        let data_ref: &Data = borrow_global<Data>(addr);
        data_ref.val
    }
}



//# publish
module 0xCAFE::FriendB {
    use std::signer;
    use std::borrow_global;
    use std::borrow_global_mut;
    use 0xCAFE::FriendA;

    friend 0xCAFE::FriendA;

    public fun modify_data(account: signer, new_val: u64) acquires FriendA::Data {
        let addr = signer::address_of(&account);
        let data_mut_ref: &mut FriendA::Data = borrow_global_mut<FriendA::Data>(addr);
        data_mut_ref.val = new_val;
    }

    public fun read_data_via_borrow(account: signer): u64 acquires FriendA::Data {
        let addr = signer::address_of(&account);
        let data_ref: &FriendA::Data = borrow_global<FriendA::Data>(addr);
        // Immutable borrow with '&' in expression
        let data_val_ref = &data_ref.val;
        *data_val_ref
    }

    public fun call_friendA_read(account: signer): u64 acquires FriendA::Data {
        FriendA::read_data(account)
    }
}



//# run 0xCAFE::FriendA::create_data --signers 0xBEEF --args 42u64



//# run 0xCAFE::FriendB::read_data_via_borrow --signers 0xBEEF



//# run 0xCAFE::FriendB::call_friendA_read --signers 0xBEEF



//# run 0xCAFE::FriendB::modify_data --signers 0xBEEF --args 100u64



//# run 0xCAFE::FriendB::read_data_via_borrow --signers 0xBEEF
