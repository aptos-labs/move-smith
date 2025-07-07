//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    struct Counter has store, key {
        val: u64,
    }

    /// Initialize a counter resource at the signer's address.
    public fun init_counter(s: signer) {
        let counter = Counter { val: 0 };
        move_to<Counter>(&s, counter);
    }

    /// Increment the stored counter using a |u64|u64 lambda.
    public fun increment_lambda(s: signer, amount: u64) {
        let lambda: |u64|u64 has copy + drop = |x: u64| { x + 1 };
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(&s));
        counter_ref.val = lambda(counter_ref.val);
        counter_ref.val = counter_ref.val + amount;
    }

    /// Use a || lambda (takes no arguments) to reset the counter to zero.
    public fun reset_lambda(s: signer) {
        let reset_fn: ||u64 has copy + drop = || { 0 };
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(&s));
        counter_ref.val = reset_fn();
    }

    /// Read the counter value.
    public fun read_counter(s: signer): u64 {
        let counter_ref = borrow_global<Counter>(signer::address_of(&s));
        counter_ref.val
    }

    /// Global invariant ensuring the counter value is always less than 100.
    #[invariant]
    public fun counter_less_than_100(addr: address): bool acquires Counter {
        if (exists<Counter>(addr)) {
            let counter_ref = borrow_global<Counter>(addr);
            counter_ref.val < 100
        } else {
            true
        }
    }

    /// Runner function doing all steps for tests
    public fun runner(s: signer) {
        init_counter(s);
        increment_lambda(s, 5);
        reset_lambda(s);
    }
}

//# run 0xCAFE::LambdaTest::runner --signers 0xBEEF

//# run 0xCAFE::LambdaTest::init_counter --signers 0xABCD

//# run 0xCAFE::LambdaTest::increment_lambda --signers 0xABCD --args 99u64

//# run 0xCAFE::LambdaTest::read_counter --signers 0xABCD

//# run 0xCAFE::LambdaTest::reset_lambda --signers 0xABCD

//# run 0xCAFE::LambdaTest::read_counter --signers 0xABCD

// Featurres:
// ad7453a2440777ced4dd4d4144bbd90d: Use custom module names when declaring modules.
// 31339dd99238e13add680fcfd365beb5: Reference memory used in global invariants to ensure correct usage in your specifications.
// 40371b5668a176b407716e3629c12949: Create lambda (anonymous) functions using pipe '|' or double-pipe '||' syntax for parameter binding.
