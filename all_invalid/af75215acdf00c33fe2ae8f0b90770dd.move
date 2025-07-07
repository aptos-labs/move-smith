//# publish
address 0x1 {
    module Dep {
        use std::signer;

        #[skip(empty_method,unused_variables)]
        struct R has key {
            value: u64,
        }

        public fun create_r(account: &signer, val: u64) {
            move_to(account, R { value: val });
        }

        public fun get_r_value(owner: address): u64 acquires R {
            borrow_global<R>(owner).value
        }

        public fun modify_r(owner: &signer, v: u64) acquires R {
            let r_ref = borrow_global_mut<R>(signer::address_of(owner));
            // Logic that depends on v
            if (v % 2 == 0) {
                r_ref.value = r_ref.value + v;
            } else {
                // Multiply for odd values
                r_ref.value = r_ref.value * v;
            }
        }

        // Runner function that does a sequence of modifications to R
        public fun do(account: &signer) acquires R {
            modify_r(account, 4);
            modify_r(account, 3);
            modify_r(account, 10);
        }
    }
}

//# run 0x1::Dep::do --signers 0x1

//# publish
address 0x1 {
    module Target {
        use std::signer;
        use 0x1::Dep;

        #[skip(empty_block)]
        public fun test_interactions(account: &signer) acquires Dep::R {
            // Create initial R resource with value 1
            Dep::create_r(account, 1);

            // Call do() which modifies R several times
            Dep::do(account);

            // Read final value for testing purposes (no assertions needed)
            let _res = Dep::get_r_value(signer::address_of(account));

            // Further modify with an odd number to test odd branch again
            Dep::modify_r(account, 7);
        }
    }
}

//# run 0x1::Target::test_interactions --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::Dep;
    use 0x1::Target;

    fun main(account: signer) {
        // Directly create and then modify the resource R to test compiler and VM behavior
        Dep::create_r(&account, 5);
        Dep::modify_r(&account, 2);
        Dep::modify_r(&account, 3);
        let val = Dep::get_r_value(signer::address_of(&account));
        // call target test function to run full scenario
        Target::test_interactions(&account);
    }
}