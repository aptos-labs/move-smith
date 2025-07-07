//# publish
module 0xabc::variable_update_test {
    // This module will define a function to test variable reassignment within nested conditionals
    public fun update_in_if() {
        let mut value = 5;
        if (true) {
            value = 10;
            if (false) {
                value = 20;
            } else {
                value = 15;
            }
        } else {
            value = 0;
        }
        // value should now be 15
        value
    }

    public fun run_test(): u64 {
        update_in_if()
    }
}

//# run 0xabc::variable_update_test::run_test

//# publish
module 0xabc::identity_plus {
    // Defines a simple identity function
    fun identity(x: u64): u64 {
        x
    }

    // A function that calls identity multiple times and then adds 10 to result
    public fun compute(): u64 {
        let a = identity(7);
        let b = identity(a);
        let c = identity(b);
        c + 10
    }
}

//# run 0xabc::identity_plus::compute

//# publish
module 0xabc::cap_resource_management {
    struct Cap1 has copy, store {
        owner: address
    }

    struct Cap2 has copy, store {
        owner: address
    }

    struct Cap3 has copy, store {
        owner: address
    }

    struct Store has key {
        cap3: Cap3
    }

    fun cleanup_and_return(s: &signer): (Cap1, Cap3) {
        let cap1 = Cap1 { owner: signer::address_of(s) };
        let cap2 = Cap2 { owner: signer::address_of(s) };
        let cap3 = Cap3 { owner: signer::address_of(s) };

        // Move cap3 into storage
        move_to(s, Store { cap3 });

        // Destroy cap2 resource
        destroy_cap2(cap2);

        (cap1, cap3)
    }

    fun destroy_cap2(c: Cap2) {
        // Destroy resource by simply dropping it
        // (In real scenario, might need more logic)
        // move c into destructive operation
        // move c to the discard
        discard c;
    }
}

//# run 0xabc::cap_resource_management::cleanup_and_return --args <signer_address>