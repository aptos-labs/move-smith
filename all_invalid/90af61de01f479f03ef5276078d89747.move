// Test for feature 1: Filter out test members during compilation

//# publish
module 0xCAFE::TestFilter {
    // This constant should be included.
    const PROD_CONST: u8 = 42;

    // This function should be included.
    public fun prod_function(): u8 {
        Self::PROD_CONST
    }

    #[test]
    fun test_function() {
        // This is a test-only member.
        assert!(Self::prod_function() == 42, 0);
    }

    #[test_only]
    const TEST_CONST: u8 = 99;
}

//# run 0xCAFE::TestFilter::prod_function

// Test for feature 2: Detect and report unbound/undefined constants

//# publish
module 0xDEAD::UndefinedConstant {
    // This const is intentionally undefined to trigger a compiler error.
    //public fun use_undefined_const(): u64 {
    //    // The following line should fail to compile
    //    UNDEFINED_CONST
    //}

    // Instead, we define a runner that tries to access a non-existent constant.
    public fun runner(): u64 {
        0xDEAD::UndefinedConstant::UNDEFINED_CONST
    }
}

//# run 0xDEAD::UndefinedConstant::runner

// Test for feature 3: Resource access, mutation, existence, error handling

address 0xBEEF {
    module ResourceTest {
        // A simple resource
        struct MyResource has key {
            value: u64,
        }

        // Publish the resource to the sender's account
        public fun publish_resource(account: &signer, val: u64) {
            move_to(account, MyResource { value: val });
        }

        // Check for existence of the resource
        public fun exists_resource(addr: address): bool {
            exists<MyResource>(addr)
        }

        // Mutate the resource's value if it exists and return new value
        public fun mutate_resource(account: &signer, delta: u64): u64 {
            let res = borrow_global_mut<MyResource>(signer::address_of(account));
            res.value = res.value + delta;
            res.value
        }

        // Remove the resource
        public fun remove_resource(account: &signer) {
            let _r = move_from<MyResource>(signer::address_of(account));
        }

        // Runner function to demonstrate all operations
        public fun runner(account: &signer) {
            // Publish resource
            Self::publish_resource(account, 100);
            // Check existence
            assert!(Self::exists_resource(signer::address_of(account)), 102);
            // Mutate it
            let new_val = Self::mutate_resource(account, 23);
            assert!(new_val == 123, 202);
            // Remove it
            Self::remove_resource(account);
            // Now check that it does NOT exist
            assert!(!Self::exists_resource(signer::address_of(account)), 302);
            // Try to remove again (should throw an abort at runtime)
            //Self::remove_resource(account); // Uncomment to trigger error
        }
    }
}

//# run 0xBEEF::ResourceTest::runner --signers 0xBEEF