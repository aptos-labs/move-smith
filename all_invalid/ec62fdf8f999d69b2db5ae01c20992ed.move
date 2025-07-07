// # Feature 1: Filter out test members from the program during compilation

//# publish
module 0x1::TestFilterModule {
    /// Not a test, just a public function
    public fun normal_fn(): u8 {
        1
    }

    /// Move test function: should be filtered out and not compiled for runtime
    #[test]
    public fun test_addition() {
        let a = 1u8 + 1u8;
        assert!(a == 2u8, 0);
    }

    /// Move test only constant (should be filtered out for runtime)
    #[test_only]
    const TEST_ONLY_CONST: u8 = 42;

    /// Runner function, to verify module is functional
    public fun runner(): u8 {
        normal_fn()
    }
}

//# run 0x1::TestFilterModule::runner --signers 0x1

// # Feature 2: Detect and report unbound or undefined constants during compilation

//# publish
module 0x2::UndefinedConstModule {
    // Intentionally reference a constant that is not defined
    public fun bad_const_usage(): u8 {
        // This should cause a compilation error since NO_SUCH_CONST is not defined in this module or imported
        NO_SUCH_CONST
    }
}

// NOTE: No run directive for bad_const_usage, because the compilation itself should fail and be tested at compile time

// # Feature 3: Test global resource access, mutation, existence checks, and error handling

//# publish
module 0x3::ResourceTest {
    struct R has key, store {
        val: u64,
    }

    public fun publish(s: &signer, v: u64) {
        move_to<R>(s, R { val: v });
    }

    public fun mutate(s: &signer, v: u64) acquires R {
        let r = borrow_global_mut<R>(signer::address_of(s));
        r.val = v;
    }

    public fun exists(addr: address): bool {
        exists<R>(addr)
    }

    public fun remove(s: &signer) acquires R {
        let _r = move_from<R>(signer::address_of(s));
        // drop resource
    }

    // Try unauthorized access (should abort if resource is not found)
    public fun bad_remove(addr: address) acquires R {
        let _r = move_from<R>(addr);
        // drop resource
    }

    public fun runner(s: &signer) acquires R {
        // Test all features: publish, mutate, exists, remove, and unauthorized
        let my_addr = signer::address_of(s);
        assert!(!exists<R>(my_addr), 100);
        publish(s, 64);
        assert!(exists<R>(my_addr), 101);
        mutate(s, 77);
        remove(s); // Should be successful, no resource anymore

        // This line should abort at runtime (no such resource)
        // bad_remove(my_addr); // Uncomment to check error handling
    }
}

//# run 0x3::ResourceTest::runner --signers 0x3

//# run 0x3::ResourceTest::mutate --signers 0x3 --args 54u64

//# run 0x3::ResourceTest::remove --signers 0x3

//# run 0x3::ResourceTest::bad_remove --args 0x3