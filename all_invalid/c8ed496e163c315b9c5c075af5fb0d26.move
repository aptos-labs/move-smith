//# publish
address 0x1 {
    module TestModule {
        use std::signer;

        #[skip(lint::unused_variable, lint::dead_code)]
        struct R has key {
            val: u64,
        }

        struct S has key {
            r: R, // explicit type annotation
        }

        public fun initialize(s: &signer) {
            move_to(s, S { r: R { val: 0 } });
        }

        public fun do(s: &signer, v: u64) {
            let s_ref = borrow_global_mut<S>(signer::address_of(s));
            if (v == 0) {
                s_ref.r.val = 42;
            } else {
                s_ref.r.val = v;
            }
        }

        public fun runner(s: &signer) {
            initialize(s);
            do(s, 0);
            do(s, 123);
        }
    }
}
//# run 0x1::TestModule::runner --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::TestModule;

    fun main(account: signer) {
        TestModule::initialize(&account);
        TestModule::do(&account, 0);
        TestModule::do(&account, 999);
    }
}