//# publish
module 0xA550C18::FriendModule {
    use std::signer;

    // Define a struct with multiple fields
    struct MyStruct has key {
        field1: u64,
        field2: address,
        field3: bool,
    }

    // Private data only accessible by this module and friends
    struct SecretData has key {
        value: u8,
    }

    // initialize SecretData for an address
    public fun init_secret(account: &signer, val: u8) {
        move_to(account, SecretData { value: val });
    }

    friend 0xA550C18::FriendUser;

    // Return the secret value, only accessible by FriendUser
    public(friend) fun get_secret(data: &SecretData): u8 {
        data.value
    }
}

//# publish
module 0xA550C18::FriendUser {
    use std::signer;
    use 0xA550C18::FriendModule;

    // Function that creates MyStruct and unpacks it
    public fun create_and_unpack(account: &signer) {
        // Create a MyStruct instance
        let s = FriendModule::MyStruct {
            field1: 10u64,
            field2: signer::address_of(account),
            field3: true,
        };

        // Destructure / unpack the struct fields
        let FriendModule::MyStruct { field1, field2, field3 } = s;

        // Use the values (dummy usage)
        let _sum = field1 + 1;
        let _same_addr = field2;
        let _cond = field3;

        // Initialize SecretData for the same account using FriendModule's function
        FriendModule::init_secret(account, 42);

        // Borrow SecretData resource from account (friend access)
        let secret_ref = borrow_global<FriendModule::SecretData>(signer::address_of(account));

        // Get secret value using friend function
        let secret_val = FriendModule::get_secret(secret_ref);

        let val = secret_val + 1;
        // dummy usage of val to avoid unused variable warning
        let _ = val;
    }

    // Runner function without arguments
    public fun run(account: &signer) {
        create_and_unpack(account);
    }
}

//# run 0xA550C18::FriendUser::run --signers 0xA550C18

//# run
script {
    use std::signer;
    use 0xA550C18::FriendUser;

    fun main(account: signer) {
        FriendUser::run(&account);
    }
}