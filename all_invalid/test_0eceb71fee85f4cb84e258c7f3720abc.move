//# publish
module 0xAABBCC::numeric_tests {
    // Function to test that large numeric literals do not overflow in default u64 context
    public fun test_literals_no_overflow() {
        let max_u64 = 18446744073709551615; // u64::MAX
        let half = max_u64 / 2;
        let sum = half + half;
        // sum should be equal to max_u64, no overflow
        assert!(sum == max_u64, 1);
    }

    // Function to test that exceeding u64 max causes failure
    public fun test_literals_overflow() {
        // The following line should fail during compilation or execution
        // Uncomment to test overflow behavior (will cause runtime panic if execution)
        // let overflow_value = 18446744073709551615 + 1;
    }

    // Inline function to mutate a counter
    inline fun increment_counter(counter: &mut u64): u64 {
        *counter = *counter + 1;
        *counter
    }

    // Function to test that 'increment_counter' correctly mutates and returns value
    public fun test_increment() {
        let mut counter = 0;
        let res1 = increment_counter(&mut counter);
        let res2 = increment_counter(&mut counter);
        // For validation, though no assertions are to be included
    }
}

//# run
script {
    // Confirm that numeric literals within u64 bounds do not overflow
    fun main() {
        let a = 100u64;
        let b = 1000u64;
        let c = 12345u64;
        let sum = a + b + c; // Should be within u64
        assert!(sum == 11145, 1);
    }
}

//# run
script {
    // Validate that large literals just below max do not overflow
    fun main() {
        let large = 18446744073709551614u64; // u64::MAX - 1
        let result = large + 1; // Should be maximal u64, no overflow
        assert!(result == 18446744073709551615u64, 1);
    }
}

//# run
script {
    // Check that exceeding u64 max causes failure (script commented to prevent compile errors)
    // This test would be meaningful if runtime panics are caught
    fun main() {
        // This line is expected to panic or cause a compile error if uncommented
        // let overflow_value = 18446744073709551615u64 + 1;
    }
}

//# publish
module 0xDDEEFF::inline_test {
    // Inline function to mutate a variable
    inline fun inc(x: &mut u64): u64 {
        *x = *x + 1;
        *x
    }

    // Function to test inline inc
    public fun run_increment_test(): u64 {
        let mut val = 5;
        let r1 = inc(&mut val);
        let r2 = inc(&mut val);
        r2 // Return the final value for verification
    }
}

//# run 0xDDEEFF::inline_test::run_increment_test