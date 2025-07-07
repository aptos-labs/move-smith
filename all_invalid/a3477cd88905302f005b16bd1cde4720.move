//# publish
address 0x1 {
    module Target {
        use std::signer;

        #[skip(lint_unreachable, lint_unused_variable)]
        struct R has key { value: u64 }

        public fun initialize(account: &signer) {
            move_to(account, R { value: 0 });
        }

        public fun do(account: &signer, v: u64) {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (v == 0) {
                r.value = 42;
            } else {
                r.value = r.value + v;
            }
        }

        public fun runner(account: &signer) {
            do(account, 0);
            do(account, 10);
        }
    }

    // Override an experiment flag for demonstration purposes (fictional flag `exp_do_override`)
    // This does not affect runtime but will test the compiler's handling of experiment flags.
    #[experiment(exp_do_override=on, exp_unused_flag=off)]
    module Dep {
        public fun dummy() {}
    }
}

//# run 0x1::Target::runner --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::Target;

    fun main(account: signer) {
        Target::initialize(&account);
        Target::do(&account, 0);
        Target::do(&account, 5);
        Target::do(&account, 100);
    }
}