//# publish
address 0x1 {
    module TestModule {
        use std::signer;

        #[skip(dead_code, unused_variables)]
        struct R has key {
            val: u64,
        }

        public fun init_r(account: &signer) {
            // Create the resource R with initial val
            move_to(account, R { val: 0 });
        }

        public fun get_r_ref(account: &signer): &R {
            &borrow_global<R>(signer::address_of(account))
        }

        public fun do(account: &signer, v: u64) {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (v == 0) {
                // Do not update val if 0
                return;
            } else if (v == 1) {
                // Increment val by 1
                r.val = r.val + 1;
            } else {
                // Set val to v
                r.val = v;
            }
        }

        public fun runner(account: &signer) {
            // Init R resource
            init_r(account);
            // Call do with 1 (should increment val)
            do(account, 1);
            // Call do with 0 (should not change val)
            do(account, 0);
            // Call do with 10 (should set val to 10)
            do(account, 10);
        }
    }
}

//# run 0x1::TestModule::runner --signers 0x1


//# publish
address 0x2 {
    module Dependency {
        #[skip(unused_imports)]
        public fun helper_add(x: u64, y: u64): u64 {
            x + y
        }
    }
}


//# publish
address 0x3 {
    module UseDep {
        use 0x2::Dependency;
        use std::signer;

        struct Wrapper has key {
            v: u64,
        }

        public fun publish_wrapper(account: &signer, v: u64) {
            let wrapped = Wrapper { v };
            move_to(account, wrapped);
        }

        public fun update_wrapper(account: &signer, addend: u64) {
            let w = borrow_global_mut<Wrapper>(signer::address_of(account));
            w.v = Dependency::helper_add(w.v, addend);
        }

        public fun runner(account: &signer) {
            publish_wrapper(account, 5);
            update_wrapper(account, 10);
        }
    }
}

//# run 0x3::UseDep::runner --signers 0x3


//# run
script {
    use 0x1::TestModule;
    use 0x3::UseDep;
    use std::signer;

    fun main(account: signer) {
        TestModule::init_r(&account);
        TestModule::do(&account, 1);
        TestModule::do(&account, 2);
        TestModule::do(&account, 0);

        UseDep::publish_wrapper(&account, 4);
        UseDep::update_wrapper(&account, 6);
    }
}