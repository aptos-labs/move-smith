module 0x1::TransactionalTest {

    /// A simple resource with a single u64 field to track state changes
    struct Counter has key {
        value: u64,
    }

    /// Initializes a Counter resource with initial value 0
    public fun init_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    /// Returns a reference to the Counter resource
    public fun borrow_counter(account: &signer): &mut Counter {
        borrow_global_mut<Counter>(Signer::address_of(account))
    }

    /// Increments the counter by `amount`
    public fun increment_counter(counter: &mut Counter, amount: u64) {
        counter.value = counter.value + amount;
    }

    /// Gets the current value of the counter
    public fun get_value(counter: &Counter): u64 {
        counter.value
    }

    #[test]
    public fun test_modifying_mutable_resource_in_loop(): bool {
        let account = @0x1;
        // Simulate signer with account address 0x1
        let signer_ref = Signer::borrow_address(&account);

        // 1. Initialize Counter resource
        init_counter(&Signer::new(account));

        // 2. Borrow mutable reference to Counter
        let counter_ref = borrow_counter(&Signer::new(account));

        // 3. Use a local variable as loop counter
        let mut i = 0u64;
        let loop_limit = 5u64;

        // 4. Loop incrementing counter.value by i each iteration
        while (i < loop_limit) {
            // Using local variables in an expression to reference i and counter_ref
            let increment_amount = i + 1;
            increment_counter(counter_ref, increment_amount);

            i = i + 1;
        };

        // 5. Verification: sum of 1 to 5 is 15, so counter.value should be 15
        // Use local variable expression to capture value
        let final_value = get_value(counter_ref);

        // Assert final_value == 15, returning true if so
        final_value == 15
    }
}

// Featurres:
// b72568104d2d12683da5cb358663f767: Declare or use identifiers (such as variable or function names) in code.
// 7dffe8f03b6cccc2e3f2ff4865b529eb: Test that modifying a mutable resource within a loop updates its state correctly and that the modifications produce expected values without causing bytecode verifier errors.
// 16c15a93294020172ad548fa24cf7bab: Use local variable expressions to reference variables within a scope.
