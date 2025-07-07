//# publish
address 0xA550C18 {
    module TestModule1 {
        use std::signer;

        #[skip(lint_unused_variable, lint_shadowing)]
        struct R has key {
            val: u64,
        }

        public fun create_r(account: &signer, v: u64) {
            move_to(account, R { val: v });
        }

        public fun read_r(addr: address): u64 acquires R {
            borrow_global<R>(addr).val
        }

        public fun do(account: &signer, v: u64) acquires R {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (v > 10) {
                r.val = r.val + v;
            } else {
                r.val = r.val - v;
            }
        }

        public fun runner(account: &signer) acquires R {
            // create R with 5
            create_r(account, 5);
            // do modifies R.val by subtracting 3 (since 3 <= 10)
            do(account, 3);
            // do modifies R.val by adding 20 (since 20 > 10)
            do(account, 20);
        }
    }
}
//# run 0xA550C18::TestModule1::runner --signers 0xA550C18

//# publish
address 0xBEEF {
    module DependentModule {
        use std::signer;
        use 0xA550C18::TestModule1;

        #[skip(lint_dead_code)]
        public fun dependent_runner(account: &signer) acquires TestModule1::R {
            TestModule1::create_r(account, 15);
            TestModule1::do(account, 5);
            TestModule1::do(account, 50);
        }
    }
}
//# run 0xBEEF::DependentModule::dependent_runner --signers 0xBEEF

//# run
script {
    use std::signer;
    use 0xA550C18::TestModule1;

    fun main(account: &signer) {
        TestModule1::create_r(account, 100);
        TestModule1::do(account, 7);
        TestModule1::do(account, 25);
        let val = TestModule1::read_r(signer::address_of(account));
        // Just to test VM, no assertions needed.
    }
}