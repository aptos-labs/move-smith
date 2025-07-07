//# publish
address 0x1 {
    module M {
        use std::signer;

        #[skip(liquidateable, unused_imports)]
        struct R has key {
            val: u64,
        }

        /// Create a new R resource with val = 0
        public fun init(): R {
            R { val: 0 }
        }

        /// Modify resource R based on input v
        public fun do(r: &mut R, v: u64) {
            if (v % 2 == 0) {
                r.val = r.val + v;
            } else {
                r.val = r.val * v;
            }
        }

        /// "Runner" function to test do()
        public fun runner(s: &signer) {
            // Publish R resource under signer
            let r = init();
            move_to(s, r);

            // Borrow R and call do()
            let r_ref = borrow_global_mut<R>(signer::address_of(s));
            do(r_ref, 10); // even number, val += 10
            do(r_ref, 3);  // odd number, val *= 3
        }
    }
}
//# run 0x1::M::runner --signers 0x1

//# publish
address 0x2 {
    module Dep {
        use std::signer;

        /// Demonstrates type domain usage
        struct DomainExample has copy, drop, store { }

        /// Resource with a type parameter with domain `'d` 
        struct R<'d> has key {
            val: u64,
            phantom: phantom::PhantomData<&'d u64>,
        }

        /// Create R<'d> resource with val = 0
        public fun init<'d>() : R<'d> {
            R<'d> { val: 0, phantom: phantom::PhantomData }
        }

        /// Modify R<'d> resource value
        public fun do<'d>(r: &mut R<'d>, v: u64) {
            if (v > 100) {
                r.val = 100;
            } else {
                r.val = v;
            }
        }

        /// Runner for Dep module
        public fun runner(s: &signer) {
            let r = init<'static>();
            move_to(s, r);

            let r_ref = borrow_global_mut<R<'static>>(signer::address_of(s));
            do(r_ref, 150);
            do(r_ref, 42);
        }
    }
}
//# run 0x2::Dep::runner --signers 0x2

//# run
script {
    use std::signer;
    use 0x1::M;
    use 0x2::Dep;

    fun main(accounts: vector<signer>) {
        let acct1 = vector::pop_back(&mut accounts);
        let acct2 = vector::pop_back(&mut accounts);

        M::runner(&acct1);
        Dep::runner(&acct2);
    }
}