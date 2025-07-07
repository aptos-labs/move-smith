//# publish
module 0x1234::Counter {
    // Initializes the counter with a given value
    public fun initialize(account: &signer, start_value: u64) {
        move_to(account, Counter { value: start_value });
    }

    // Increments the counter by a specified amount
    public fun increment(counter_addr: address, amount: u64) {
        let counter_ref = borrow_global_mut<Counter>(counter_addr);
        counter_ref.value = counter_ref.value + amount;
    }

    // Decrements the counter by a specified amount
    public fun decrement(counter_addr: address, amount: u64) {
        let counter_ref = borrow_global_mut<Counter>(counter_addr);
        assert!(counter_ref.value >= amount, 1);
        counter_ref.value = counter_ref.value - amount;
    }

    // Gets the current value of the counter
    public fun get_value(counter_addr: address): u64 acquires Counter {
        let counter_ref = borrow_global<Counter>(counter_addr);
        counter_ref.value
    }

    struct Counter {
        value: u64,
    }
}

//# run 0x1234::Counter::initialize --signers 0xABCDE --args 20u64
//# run 0x1234::Counter::increment --signers 0xABCDE --args 15u64
//# run 0x1234::Counter::decrement --signers 0xABCDE --args 10u64
//# run 0x1234::Counter::get_value --signers 0xABCDE --args 0xABCDE

//# publish
module 0xABCD::CounterTest {
    use 0x1234::Counter;

    // Runner to initialize counter, perform increments and decrements, and verify final value
    public fun run_counter_test(account: &signer) {
        // Initialize with 5
        Counter::initialize(account, 5);
        // Increment by 10, new value should be 15
        Counter::increment(&signer::address_of(account), 10);
        // Decrement by 3, new value should be 12
        Counter::decrement(&signer::address_of(account), 3);
        // Decrement by 12 to test edge case (zero)
        Counter::decrement(&signer::address_of(account), 12);
        // Final value should be 0
        let final_value = Counter::get_value(signer::address_of(account));
        // Optionally, here you could add assertions or return anything
        // But as per the instructions, we focus on the test steps
        // For demonstration, assume test checks pass if no assertion fails
        // and the value is as expected
        assert!(final_value == 0, 2);
    }
}

//# run 0xABCD::CounterTest::run_counter_test --signers 0xABCDE