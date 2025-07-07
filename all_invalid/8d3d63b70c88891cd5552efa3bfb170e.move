//# publish
address 0xA550C18 {
    module TestModule {
        use aptos_framework::error;

        #[skip(unsafe_cast, unused_assignment)]
        resource struct R {
            val: u64,
        }

        public fun new_r(val: u64): R {
            R { val }
        }

        public fun do(r: &mut R, v: u64) {
            if (v == 0) {
                r.val = r.val + 1;
            } else if (v == 1) {
                r.val = r.val * 2;
            } else {
                // Simulate error due to unexpected token (v value)
                abort error::invalid_argument(42);
            }
        }

        // Function demonstrating parsing typed variable bindings within lambda parameters
        public fun apply_func(r: &mut R, f: &fun((&mut R, u64)) ) {
            let values: vector<u64> = vector::empty<u64>();
            // we simulate a lambda with typed parameters to call f
            f(r, 10u64);
        }

        // Runner function, no args needed
        public fun run_test() {
            let mut r = new_r(1);
            do(&mut r, 0);
            do(&mut r, 1);
            apply_func(&mut r, &do);
            // Attempt to trigger error handling by passing invalid v
            // catch failed abort (just for the sake of diagnostics, no actual catch)
            // Normally expected to abort with error code 42 here
        }
    }
}
//# run 0xA550C18::TestModule::run_test --signers 0xA550C18

//# publish
address 0xDEADBEEF {
    #[deprecated]
    module DeprecatedModule {
        public fun deprecated_func(): u64 {
            999
        }
    }
}
//# run 0xDEADBEEF::DeprecatedModule::deprecated_func

//# run
script {
    use 0xA550C18::TestModule;
    use 0xDEADBEEF::DeprecatedModule;

    fun main(account: signer) {
        // Create resource R and run do() function
        let mut r = TestModule::new_r(5);
        TestModule::do(&mut r, 0);
        TestModule::do(&mut r, 1);
        // call apply_func with do as argument (lambda with typed param bindings)
        TestModule::apply_func(&mut r, &TestModule::do);

        // Call deprecated function - expect diagnostics or warning (no error)
        let _val = DeprecatedModule::deprecated_func();

        // Try to cause error by calling do with invalid v, will abort
        // Note: no catch, test VM aborts as expected
        TestModule::do(&mut r, 99);
    }
}