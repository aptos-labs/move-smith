//# publish
address 0x1 {
    module Dependency {
        // A constant value
        const CONST_VALUE: u64 = 42;

        // A constant type represented as a type alias (not native feature but just conceptual for test)
        // Since Move doesn't have constant types, we'll simply use a type alias here
        // We cannot assign const types directly, but we can test constant values and types usage
        // This is to exercise referencing constants.
        #[skip(invalid_constant)]
        const CONST_LIMIT: u8 = 100;

        struct R has key {
            val: u64,
        }

        public fun new_r(): R {
            R { val: CONST_VALUE }
        }

        // Function modifying the resource passed as mutable reference.
        public fun increment(r: &mut R, amount: u64) {
            r.val = r.val + amount;
        }

        public fun get_val(r: &R): u64 {
            r.val
        }
    }
}

//# publish
address 0x1 {
    module MainModule {
        use 0x1::Dependency::{R, new_r, increment, get_val, CONST_VALUE};
        use 0x1::Dependency::CONST_LIMIT as LIMIT_ALIAS;

        #[skip(invalid_import,unused_import)]
        use 0x1::Dependency::{R as RenamedR};

        // Runner function testing resource creation, mutation, and constant access.
        public fun do(): u64 {
            let mut r = new_r();
            // Increment R's val by 5
            increment(&mut r, 5);

            // Use constant alias in arithmetic
            let sum = get_val(&r) + (LIMIT_ALIAS as u64);

            sum
        }
    }
}

//# run 0x1::MainModule::do --signers 0x1

//# run
script {
    use 0x1::MainModule;

    fun main(account: signer) {
        let result = MainModule::do();
        // no assertions, just execution to ensure compiler + VM runs
        // result should be 42 + 5 + 100 = 147
        let _ = result;
    }
}