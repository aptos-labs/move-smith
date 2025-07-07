
//# publish
module 0xCAFE::UnitTest {
    use std::signer;

    /// A struct storing a count
    struct Counter has copy, drop, store, key {
        count: u64,
    }

    /// Initialize Counter resource at signer's address
    public fun init_counter(s: signer) {
        let counter = Counter { count: 0 };
        move_to<Counter>(&s, counter);
    }

    /// Increment the counter by 1
    public fun increment(s: signer) {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(&s));
        counter_ref.count = counter_ref.count + 1;
    }

    /// Return multiple values (a tuple)
    public fun get_counts(s: signer): (u64, u64, u64) {
        let counter_ref = borrow_global<Counter>(signer::address_of(&s));
        let a = counter_ref.count;
        let b = a + 1;
        let c = a + b;
        (a, b, c)
    }

    /// Example of rewriting specification as part of code:
    /// specification: count always >= 0
    /// We express this by checking and aborting if count is ever less than 0 (not possible in u64, but for example)
    public fun check_nonnegative(s: signer) {
        let counter_ref = borrow_global<Counter>(signer::address_of(&s));
        assert!(counter_ref.count >= 0, 999);
    }

    /// Runner function to exercise the module
    public fun runner(s: signer) {
        init_counter(s);
        increment(s);
        let (_a, _b, _c) = get_counts(s);
        check_nonnegative(s);
    }
}


//# run 0xCAFE::UnitTest::runner --signers 0xBEEF


// Featurres:
// 7bd5a885ef12418255344b5ea730c563: Define modules named 'UnitTest' in your package.
// 946f98cb5b61645c0d2428b7312cdd18: Rewrite specifications as part of code transformations.
// 1300979e3b9b7c757af6fe6978a1cea6: Declare functions that return multiple values as a tuple
