//# publish
module 0xCAFE::VisibilityInvariantTest {
    use std::debug;
    use std::signer;

    /// A resource struct to hold a counter
    struct Counter has store, key {
        value: u64,
    }

    /// A global invariant on the Counter resource to always have value <= 1000.
    global_invariant invariant_counter_le_1000(counter: &Counter): bool {
        counter.value <= 1000
    }

    /// Publish a Counter resource for the signer with initial value 0.
    public fun init_counter(account: &signer) {
        // ensure no existing Counter resource for this account
        assert!(!exists<Counter>(signer::address_of(account)), 1);
        move_to(account, Counter { value: 0 });
    }

    /// Public function to add to the counter with safe bound check.
    public fun add_to_counter(account: &signer, amount: u64) {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        let new_value = counter.value + amount;
        // The invariant requires <= 1000
        assert!(new_value <= 1000, 2);
        counter.value = new_value;
    }

    /// Public(friend) function that resets the counter to zero.
    /// This function can only be called from friend modules (not from scripts).
    public(friend) fun reset_counter_to_zero(account: &signer) {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = 0;
    }

    /// Private helper function to double the counter value unchecked.
    /// Used inside the module only.
    private fun double_counter(account: &signer) {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        // doubling can overflow, we assert safe condition
        let doubled = counter.value * 2;
        assert!(doubled <= 1000, 3);
        counter.value = doubled;
    }

    /// Public runner function that calls private double_counter without arguments.
    public fun runner(account: &signer) {
        double_counter(account);
    }
}
//# run 0xCAFE::VisibilityInvariantTest::init_counter --signers 0xCAFE
//# run 0xCAFE::VisibilityInvariantTest::add_to_counter --signers 0xCAFE --args 10u64
//# run 0xCAFE::VisibilityInvariantTest::runner --signers 0xCAFE
//# run 0xCAFE::VisibilityInvariantTest::reset_counter_to_zero --signers 0xCAFE



//# publish
module 0xCAFE::ComparisonRewriteTest {
    /// To test rewriting of comparison operators in Move 2.2+
    /// We will do a comparison expression that can be rewritten.
    public fun compare_rewrite_test(x: u64, y: u64): bool {
        // Using <= and < comparison operators
        // If rewriting is enabled, these will be rewritten by the VM/compiler
        let res1 = x <= y;
        let res2 = !(x > y); // same as x <= y
        let res3 = x < y;
        let res4 = !(x >= y); // same as x < y
        // combine to verify equivalences
        res1 && res2 && res3 && res4
    }

    /// A runner function with no args to exercise the comparison rewriting
    public fun runner(): bool {
        // 5 <= 10 (true) and 5 < 10 (true)
        compare_rewrite_test(5, 10)
    }
}
//# run 0xCAFE::ComparisonRewriteTest::runner



//# publish
module 0xCAFE::GlobalInvariantUpdateTest {
    use std::signer;

    struct SimpleCounter has store, key {
        count: u64,
    }

    global_invariant counter_below_500(counter: &SimpleCounter): bool {
        counter.count < 500
    }

    /// Publish SimpleCounter with initial count 0
    public fun publish_counter(account: &signer) {
        assert!(!exists<SimpleCounter>(signer::address_of(account)), 100);
        move_to(account, SimpleCounter { count: 0 });
    }

    /// Increment counter, keeping invariant
    public fun increment(account: &signer, amount: u64) {
        let counter = borrow_global_mut<SimpleCounter>(signer::address_of(account));
        let new_count = counter.count + amount;
        assert!(new_count < 500, 101);
        counter.count = new_count;
    }

    /// Function that updates the global invariant by decrementing the counter
    public fun decrement(account: &signer, amount: u64) {
        let counter = borrow_global_mut<SimpleCounter>(signer::address_of(account));
        // Ensure counter won't underflow
        assert!(amount <= counter.count, 102);
        counter.count = counter.count - amount;
    }

    /// Runner function to test increment and decrement without arguments
    public fun runner(account: &signer) {
        increment(account, 100);
        decrement(account, 50);
    }
}
//# run 0xCAFE::GlobalInvariantUpdateTest::publish_counter --signers 0xCAFE
//# run 0xCAFE::GlobalInvariantUpdateTest::runner --signers 0xCAFE



//# run
script {
    use 0xCAFE::VisibilityInvariantTest;
    use 0xCAFE::GlobalInvariantUpdateTest;
    use 0xCAFE::ComparisonRewriteTest;
    use std::signer;

    fun main(account: signer) {
        // Initialize the Counter resource
        VisibilityInvariantTest::init_counter(&account);
        VisibilityInvariantTest::add_to_counter(&account, 20);
        VisibilityInvariantTest::runner(&account);
        VisibilityInvariantTest::reset_counter_to_zero(&account);

        // Initialize SimpleCounter
        GlobalInvariantUpdateTest::publish_counter(&account);
        GlobalInvariantUpdateTest::runner(&account);

        // Test comparison rewriting returns true
        let test_result = ComparisonRewriteTest::runner();
        // no assertion needed
        let _ = test_result;
    }
}

// Featurres:
// af7bbb5f7946867a5ab8d7fd684188fa: Allow rewriting of comparison operations in Move 2.2 and above when enabled
// dde689d84bd61495715418c75c783abc: Define global invariants and global invariant updates within modules.
// 27856bf097f088e0bef1d99fc9535c12: Declare functions or modules with 'public', 'public(friend)', or 'private' visibility specifiers in Move.
