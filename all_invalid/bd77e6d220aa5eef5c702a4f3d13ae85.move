//# publish
address 0x1 {
    module TargetModule {
        struct R has store { val: u64 }

        #[skip(missing_docs, unused_variable)]
        public fun do(opt_v: u8) acquires R {
            if (opt_v == 0) {
                if (exists<R>(@0x1)) {
                    let mut r = borrow_global_mut<R>(@0x1);
                    r.val = r.val + 1;
                } else {
                    move_to(&signer::spec_signer(), R { val: 1 });
                }
            } else {
                if (exists<R>(@0x1)) {
                    let mut r = borrow_global_mut<R>(@0x1);
                    r.val = r.val + (opt_v as u64);
                }
            }
        }

        // runner with no arguments:
        public fun run_do() acquires R {
            do(0);
        }
    }

    //# run 0x1::TargetModule::run_do --signers 0x1

    // Using that we can also test optional type annotation on function
    #[skip(unused_variable)]
    public fun maybe_get_val(): Option<u64> acquires R {
        if (exists<R>(@0x1)) {
            let r = borrow_global<R>(@0x1);
            some(r.val)
        } else {
            none()
        }
    }
}

//# publish
address 0x2 {
    module DependencyModule {
        // skip lint check for missing_docs and unused_imports
        #[skip(missing_docs, unused_imports)]
        use 0x1::TargetModule;

        struct Dummy has copy {}

        public fun call_do_with_v(v: u8, signer: &signer) acquires TargetModule::R {
            // direct call with anonymous address on TargetModule
            TargetModule::do(v);
        }

        // runner that calls do with 42:
        public fun runner(s: &signer) acquires TargetModule::R {
            call_do_with_v(42, s);
        }
    }
}

//# run 0x2::DependencyModule::runner --signers 0x2

//# run 0x1::TargetModule::do --signers 0x1 --args 5u8

//# run 0x1::TargetModule::do --signers 0x1 --args 0u8

//# run 0x1::TargetModule::maybe_get_val