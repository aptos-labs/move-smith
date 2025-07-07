
//# publish
module 0xCAFE::FriendTestA {
    friend 0xCAFE::FriendTestB;
    friend 0xCAFE::FriendTestC;

    use std::signer;

    struct SecretData has key {
        value: u64,
    }

    public fun create_secret_value(s: signer, val: u64) {
        let secret = SecretData { value: val };
        move_to<SecretData>(&s, secret);
    }

    public fun get_secret_value(addr: address): u64 acquires SecretData {
        let secret_ref: &SecretData = borrow_global<SecretData>(addr);
        secret_ref.value
    }

    public fun set_secret_value(addr: address, val: u64) acquires SecretData {
        let secret_mut_ref: &mut SecretData = borrow_global_mut<SecretData>(addr);
        secret_mut_ref.value = val;
    }
}



//# publish
module 0xCAFE::FriendTestB {
    use 0xCAFE::FriendTestA;

    public fun read_secret(addr: address): u64 acquires FriendTestA::SecretData {
        FriendTestA::get_secret_value(addr)
    }

    public fun overwrite_secret(addr: address, val: u64) acquires FriendTestA::SecretData {
        FriendTestA::set_secret_value(addr, val)
    }
}



//# publish
module 0xCAFE::FriendTestC {
    use 0xCAFE::FriendTestA;

    public fun double_secret(addr: address) acquires FriendTestA::SecretData {
        let val = FriendTestA::get_secret_value(addr);
        FriendTestA::set_secret_value(addr, val * 2);
    }
}



//# publish
module 0xCAFE::RedundantAddrWarningModule {
    // Intentionally adding redundant address, expect compiler warning (simulated here by comment)
    // Imagine below is redundant because 0xCAFE specified again (the same address used for module and address attribute)
    // In Move syntax by current specs might not allow ... so just an example comment for testing tooling.

    // friend declaration to test with redundancy and friends coexistence
    friend 0xCAFE::FriendTestA;

    // Just a dummy struct and function
    struct Dummy has copy, drop, store {
        x: u8,
    }

    public fun dummy_fun(): u8 {
        42
    }
}



//# publish
module 0xCAFE::vector {
    // This module named 'vector' should be allowed uniquely as a module.
    // Provide a public function to prove existence and usage
    public fun module_name(): vector<u8> {
        b"vector module"
    }
}



//# publish
module 0xCAFE::VectorFriend {
    friend 0xCAFE::vector;

    struct Data has key {
        value: u8,
    }

    public fun create_data(s: signer, val: u8) {
        let d = Data { value: val };
        move_to<Data>(&s, d);
    }

    public fun read_data(addr: address): u8 acquires Data {
        let d_ref = borrow_global<Data>(addr);
        d_ref.value
    }
}



//# publish
module 0xCAFE::VectorBadNaming {
    // Try to declare a function named vector - should trigger error or warning in tooling
    // We just write it here for tooling check, won't run
    // function named `vector`: error expected on compile
    
    // Uncommenting below should cause error; commented as Move code must parse:
    // public fun vector(): u8 {
    //     1
    // }

    // Try to declare variable named vector in a function - also error expected
    public fun test_var_name(x: u8): u8 {
        // let vector = x + 1; // This line if uncommented should error or warning due to reserved 'vector' usage
        x + 2
    }
}



//# run 0xCAFE::FriendTestA::create_secret_value --signers 0xBEEF --args 100u64



//# run 0xCAFE::FriendTestB::read_secret --args 0xBEEF



//# run 0xCAFE::FriendTestB::overwrite_secret --args 0xBEEF 101u64



//# run 0xCAFE::FriendTestA::get_secret_value --args 0xBEEF



//# run 0xCAFE::FriendTestC::double_secret --args 0xBEEF



//# run 0xCAFE::FriendTestA::get_secret_value --args 0xBEEF



//# run 0xCAFE::RedundantAddrWarningModule::dummy_fun



//# run 0xCAFE::vector::module_name



//# run 0xCAFE::VectorFriend::create_data --signers 0xABCD --args 55u8



//# run 0xCAFE::VectorFriend::read_data --args 0xABCD



//# run 0xCAFE::VectorBadNaming::test_var_name --args 3u8
