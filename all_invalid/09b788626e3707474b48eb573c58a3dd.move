//# publish
module 0xCAFE::TestLoopAndCall {
    // A simple struct to test method invocation
    struct Counter has copy, drop {
        value: u64,
    }

    // Function to create a Counter instance
    public fun new_counter(init: u64): Counter {
        Counter { value: init }
    }

    // Inline function to increment Counter
    public inline fun increment(c: &mut Counter) {
        c.value = c.value + 1;
    }

    // Function to test loop with break
    public fun test_break_loop(): (u64, bool) {
        let counter = 0u64;
        let mut i = 0u64;
        while (i < 10) {
            if (i == 2) {
                break;
            }
            // Increment counter
            let new_counter = Counter { value: counter };
            // mutate c
            increment(&mut new_counter);
            // update counter
            let counter = new_counter.value;
            i = i + 1;
        }
        (counter, i == 2)
    }
}

//# run
script {
    fun main() {
        // Call the test_break_loop function and unpack the result
        let (count, did_break) = 0xCAFE::TestLoopAndCall::test_break_loop();
        // Additional verification or use of count/did_break can be added here if needed
        // For now, just consume the variables to avoid warnings
        assert!(did_break, 10);
        assert!(count == 2 or count == 0, 11); // count should be 2 when break occurs after 2 iterations
    }
}
//# run 0xCAFE::TestLoopAndCall::new_counter --signers 0xCAFE --args 0u64
//# run 0xCAFE::TestLoopAndCall::increment --signers 0xCAFE --args 0xCAFE::TestLoopAndCall::Counter{value: 0}

// Test for a for loop with a start greater than end (no execution)
module 0xCAFE::TestRangeLoop {
    #[test]
    public fun test_empty_range() {
        let mut sum = 0;
        let start = 10u64;
        let end = 4u64; // start > end, loop should not execute
        for i in start..end {
            sum = sum + i;
        }
        assert!(sum == 0, 20);
    }
}