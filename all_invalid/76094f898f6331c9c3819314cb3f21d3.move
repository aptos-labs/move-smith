//# publish
address 0x1 {
    module Tester {
        use std::signer;

        #[skip(unused_imports, dead_code)]
        resource struct R { val: u64 }

        public fun new_r(s: &signer, val: u64) {
            move_to<R>(s, R { val });
        }

        public fun read_r(addr: address): u64 acquires R {
            let r_ref = borrow_global<R>(addr);
            r_ref.val
        }

        public fun do(s: &signer, v: u64) acquires R {
            let addr = signer::address_of(s);
            if (!exists<R>(addr)) {
                Self::new_r(s, 0);
            };
            let r_ref = borrow_global_mut<R>(addr);
            // Modify val based on v
            if (v % 2 == 0) {
                // even v: increment val by v
                r_ref.val = r_ref.val + v;
            } else {
                // odd v: double val
                r_ref.val = r_ref.val * 2;
            }
        }

        public fun runner(s: &signer) acquires R {
            // call do() for example v=5, then v=6
            Self::do(s, 5);
            Self::do(s, 6);
        }
    }
}
//# run 0x1::Tester::runner --signers 0x1


//# publish
address 0x2 {
    module Dep {
        #[skip(dead_code)]
        public fun dep_func(): u64 {
            42
        }
    }
}

//# publish
address 0x3 {
    module Main {
        use 0x2::Dep;
        use std::signer;

        #[skip(unused_variables)]
        public fun call_dep_and_do(s: &signer, v: u64) acquires 0x1::Tester::R {
            let val = Dep::dep_func();
            // call do with v + val to test dependency files and address mappings
            0x1::Tester::do(s, v + val);
        }

        public fun runner(s: &signer) acquires 0x1::Tester::R {
            // call with some test values
            Self::call_dep_and_do(s, 1);
            Self::call_dep_and_do(s, 2);
        }
    }
}
//# run 0x3::Main::runner --signers 0x3


//# run
script {
    use std::signer;
    use 0x1::Tester;

    fun main(account: signer) {
        // Publish and initialize R here by calling new_r
        Tester::new_r(&account, 10);

        // Call do() with some values to test modification
        Tester::do(&account, 4);  // even, val += 4 -> 14
        Tester::do(&account, 3);  // odd, val *= 2 -> 28

        // Call runner to run combined tests
        Tester::runner(&account);
    }
}