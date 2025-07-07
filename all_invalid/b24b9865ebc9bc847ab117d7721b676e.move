//# publish
address 0x1 {
    module Dependency {
        use std::signer;

        struct R has key {
            v: u64,
        }

        public fun create_r(account: &signer, val: u64) {
            move_to(account, R { v: val });
        }

        public fun read_r(addr: address): u64 acquires R {
            let r = borrow_global<R>(addr);
            r.v
        }
    }
}

//# publish
address 0x2 {
    module Target {
        use std::signer;
        use 0x1::Dependency;

        #[skip(lint_warnings, lint_dead_code)]
        struct RHolder has key {
            marker: u8,
        }

        public fun init(account: &signer) {
            // Create R resource with initial v=0
            Dependency::create_r(account, 0);
            move_to(account, RHolder { marker: 0 });
        }

        #[skip(lint_unused_variable)]
        public fun do(account: &signer, v: u64) acquires Dependency::R {
            // if v is even increment R.v; if odd decrement
            let addr = signer::address_of(account);
            let r = borrow_global_mut<Dependency::R>(addr);
            if (v % 2 == 0) {
                r.v = r.v + 1;
            } else {
                r.v = r.v - 1;
            }
        }

        public fun runner(account: &signer) acquires Dependency::R {
            // Calls do twice, once with even and once with odd v
            do(account, 2);
            do(account, 3);
        }
    }
}
//# run 0x2::Target::runner --signers 0x2

//# run
script {
    use std::signer;
    use 0x2::Target;
    use 0x1::Dependency;

    fun main(account: signer) {
        // Initialize resources
        Target::init(&account);

        // Run do function by runner
        Target::runner(&account);

        // Interact with Dependency::R directly to verify v changes (ignored assertions)
        let v = Dependency::read_r(signer::address_of(&account));

        // no asserts needed — just exercising VM and compiler
    }
}