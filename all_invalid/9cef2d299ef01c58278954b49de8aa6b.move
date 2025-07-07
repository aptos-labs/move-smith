
//# publish
module 0xCAFE::LoopAndBreakTest {
    struct Counter has copy, drop, store {
        count: u8,
        limit: u8,
    }

    public fun new_counter(limit: u8): Counter {
        Counter {count: 0, limit} // field shorthand for limit: limit
    }

    public fun run_loop_with_immediate_break(limit: u8): u8 {
        let counter = new_counter(limit);
        loop {
            break;
        };
        // After the immediate break, counter.count should be 0
        counter.count
    }

    public fun run_loop_increment_until_limit(limit: u8): u8 {
        let counter = new_counter(limit);
        loop {
            if (counter.count >= counter.limit) {
                break;
            };
            counter.count = counter.count + 1;
        };
        counter.count
    }

    // Utility function to demonstrate source location tracking with identity
    native public fun get_source_location(): vector<u8>;

    native public fun identity_with_location(x: u8): u8;

    public fun test_identity_with_location(x: u8): u8 {
        identity_with_location(x)
    }
}


//# run 0xCAFE::LoopAndBreakTest::run_loop_with_immediate_break --args 10u8


//# run 0xCAFE::LoopAndBreakTest::run_loop_increment_until_limit --args 5u8


//# run 0xCAFE::LoopAndBreakTest::test_identity_with_location --args 42u8


// Featurres:
// 62241665497edacd4b34bf3a1477ce1b: Test that the Move language correctly parses and handles a `loop` statement immediately followed by a `break`.
// c4030513fc468e6c92fc0d964a0c1ede: Use field shorthand syntax where writing 'field' is equivalent to 'field: field' in struct literals or similar patterns.
// b00948efb0b3c8d1dd5276b4014b388d: Track the exact source code location of any value or syntax element within Move files
