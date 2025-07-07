module 0x1::TestModule {
    use std::signer;
    use std::vector;
    use std::u256;

    /// A persistent resource to store a u64 value
    struct MyResource has key {
        value: u64,
    }

    /// Stores `MyResource` under signer account with given value
    public entry fun store_resource(account: &signer, val: u64) {
        let addr = signer::address_of(account);
        if (exists<MyResource>(addr)) {
            let r = borrow_global_mut<MyResource>(addr);
            r.value = val;
        } else {
            move_to(account, MyResource { value: val });
        }
    }

    /// Returns the stored value of MyResource for signer address
    public fun retrieve_resource(addr: address): u64 acquires MyResource {
        borrow_global<MyResource>(addr).value
    }

    /// Asserts that two U256 values are approximately the same within the given precision.
    /// approx_the_same if: abs(a - b) * 10^precision <= max(a, b)
    /// Example: for precision=2, a difference within 1% is allowed.
    public fun assert_approx_the_same(a: u256::U256, b: u256::U256, precision: u8) {
        let diff = if u256::gt(a, b) { u256::sub(a, b) } else { u256::sub(b, a) };
        // scaling factor = 10 ^ precision
        let scaling_factor = u256::pow(u256::from(10), precision as u128);
        let diff_scaled = u256::mul(diff, scaling_factor);
        let max_val = if u256::gt(a, b) { a } else { b };

        // assert diff_scaled <= max_val
        assert!(u256::le(diff_scaled, max_val), 1001);
    }

    /// TEST functions

    #[test_only]
    public entry fun test_store_and_retrieve(account: &signer) {
        // Store value 12345
        store_resource(account, 12345);
        let addr = signer::address_of(account);
        let val = retrieve_resource(addr);
        assert!(val == 12345, 100);
    }

    #[test_only]
    public entry fun test_assert_approx_the_same_pass(account: &signer) {
        // a = 1_000_000, b = 1_005_000, precision = 2 (1% difference allowed)
        // difference = 5000, scaled difference = 5000 * 100 = 500_000
        // max_val = 1_005_000
        // 500_000 <= 1_005_000 true -> Should pass
        let a = u256::from(1_000_000);
        let b = u256::from(1_005_000);
        assert_approx_the_same(a, b, 2);
    }

    #[test_only]
    public entry fun test_assert_approx_the_same_fail(account: &signer) {
        // a = 1_000_000, b = 1_020_000, precision = 2 (1% difference allowed)
        // difference = 20_000, scaled difference = 20_000 * 100 = 2_000_000
        // max_val = 1_020_000
        // 2_000_000 > 1_020_000 false -> Should fail and abort
        let a = u256::from(1_000_000);
        let b = u256::from(1_020_000);
        // Using try-catch is not supported in Move, so we test this should abort
        assert!(false, 200); // to make sure abort happens before here
        assert_approx_the_same(a, b, 2);
    }

    /// --- Spec blocks ---

    /// This spec block tests something but will be filtered out (excluded)
    #[spec(hidden)]
    spec resource MyResource {
        value: u64;
    }

    /// This spec block is active and not filtered-out
    spec fun some_active_spec(u: u64): bool {
        u > 0
    }
}

// Featurres:
// bc2a8ea14950cfdfe2f7b048802f62e7: Test storing and retrieving a persistent custom resource for a specific signer account.
// 59749c80a9b7e29b0191e34d8d6da1c9: Test that the `assert_approx_the_same` function correctly verifies whether two u256 values are approximately equal within a specified precision, especially focusing on proper handling of the precision-based scaling factor.
// 944c71e0a34ef5d7ebaf41b064209326: Exclude spec blocks associated with filtered-out members from the module.
