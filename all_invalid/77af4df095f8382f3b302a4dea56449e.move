//# publish
module 0xCAFE::FriendModulesB {}

//# publish
module 0xCAFE::FriendModulesA {
    friend 0xCAFE::FriendModulesB;

    struct Data has store, copy, drop, key {
        val: u64,
    }

    public fun create_data(val: u64): Data {
        Data { val }
    }

    // Changes val to val+1, callable only by friend module
    public fun friend_increment(data: &mut Data) {
        data.val = data.val + 1;
    }
}

//# publish
module 0xCAFE::FriendModulesB {
    use std::signer;
    use std::vector;
    use 0xCAFE::FriendModulesA;

    // This function creates a Data struct and calls friend_increment from FriendModulesA
    public fun increment_data(_s: signer, initial_val: u64): u64 {
        let mut data = FriendModulesA::create_data(initial_val);
        FriendModulesA::friend_increment(&mut data);
        data.val
    }

    public fun pattern_loop_example(): u64 {
        let mut sum = 0u64;
        let arr = vector::from_array([1u64, 2, 3, 4, 5]);
        let len = vector::length(&arr);
        let mut i = 0u64;
        while (i < len) {
            let val = *vector::borrow(&arr, i as u64);
            if (val % 2 == 0) {
                sum = sum + val;
            } else {
                sum = sum + 1;
            };
            i = i + 1;
        };
        sum
    }

    native public fun native_add(a: u64, b: u64): u64;
}

//# run 0xCAFE::FriendModulesB::increment_data --signers 0xD0D0 --args 42u64

//# run 0xCAFE::FriendModulesB::pattern_loop_example

//# run 0xCAFE::FriendModulesB::native_add --args 5u64 10u64