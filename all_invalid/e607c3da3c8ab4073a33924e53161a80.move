//# publish
address 0x1 {
    module TargetModule {
        use std::signer;

        #[skip(unchanged_locals, bytecode)] // Example lint checks to skip
        struct R has key {
            val: u64,
        }

        public fun initialize(account: &signer) {
            move_to(account, R { val: 0 });
        }

        public fun do(account: &signer, v: u64) {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (v > 0) {
                r.val = r.val + v;
            } else {
                r.val = 42;
            }
        }

        public fun read_val(account: &signer): u64 {
            let r = borrow_global<R>(signer::address_of(account));
            r.val
        }

        public fun runner(account: &signer) {
            initialize(account);
            do(account, 10);
            do(account, 0);
        }
    }
}
//# run 0x1::TargetModule::runner --signers 0x1

//# publish
address 0x2 {
    module DependencyModule {
        use 0x1::TargetModule;
        use std::signer;

        #[skip(bytecode)] // skip some lint check on this module
        public fun run_interaction(account: &signer) {
            // Initialize R in TargetModule and call do with changing values
            TargetModule::initialize(account);
            TargetModule::do(account, 100);
            TargetModule::do(account, 0);
        }
    }
}
//# run 0x2::DependencyModule::run_interaction --signers 0x2

//# run
script {
    use 0x1::TargetModule;
    use 0x2::DependencyModule;

    fun main(account: signer) {
        // Run TargetModule runner function
        TargetModule::runner(&account);

        // Run DependencyModule function that calls TargetModule functions
        DependencyModule::run_interaction(&account);
    }
}