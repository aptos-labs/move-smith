// Feature 1: Allow parsing of empty lists when the end token immediately follows the start.
//# publish
module 0x1::EmptyListTest {
    // A function that takes an empty vector of u8
    public fun accept_empty_list(v: vector<u8>) {
        // No-op
    }

    // A runner function to call with an empty list
    public fun run() {
        let empty: vector<u8> = vector[];
        Self::accept_empty_list(empty);
    }
}
//# run 0x1::EmptyListTest::run --signers 0x1

// Feature 2: Modules with friends and access control

//# publish
module 0x2::FriendA {
    friend 0x2::FriendB;

    fun secret_function(): u64 {
        2024
    }

    public fun run_test(): u64 {
        secret_function()
    }
}

//# publish
module 0x2::FriendB {
    friend 0x2::FriendA;

    use 0x2::FriendA;

    // Only friend modules can call this internal function
    public fun call_friends_secret(): u64 {
        FriendA::secret_function()
    }

    public fun run(): u64 {
        Self::call_friends_secret()
    }
}
//# run 0x2::FriendB::run --signers 0x2

// Feature 3: Declare scripts with associated function names

//# run
script {
    fun testing_named_script(sender: &signer) {
        // Name provided: testing_named_script
        let _ = signer::address_of(sender);
    }
}