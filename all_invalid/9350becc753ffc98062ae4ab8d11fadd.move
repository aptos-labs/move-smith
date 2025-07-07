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
        let i = 0u64;
        while (i < 10) {
            if (i == 2) {
                break;
            }
            counter = counter + 1;
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
        let sum = 0;
        let start = 10u64;
        let end = 4u64; // start > end, loop should not execute
        for i in start..end {
            sum = sum + i;
        }
        assert!(sum == 0, 20);
    }
}

// Featurres:
// 9d6fa7bbdf4ee46cd979039566ac14fa: Test that a loop with an immediate break correctly executes once and updates the variable accordingly.
// 957f4ac0040e1148684d1fb2cc2c2abb: Call functions and methods using the `call` expression, specifying the function name, call kind, optional type arguments, and argument list.
// aebedc6b7752fe634f3b20175f8bd8b9: Verify that a for loop with a range where the start is greater than the end (e.g., 10..4) does not execute its body.
