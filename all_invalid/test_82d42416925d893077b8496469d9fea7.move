//# publish
module 0xabcde::range_tests {

    //# run
    /// This script tests that a for loop correctly iterates over the range from 0 to 10.
    /// It counts how many iterations occur and asserts the count equals 11 (from 0 to 10 inclusive).
    script {
        fun main(): () {
            let mut count: u64 = 0;
            for (i in 0..11) {
                // Increment count for each iteration
                count = count + 1;
            }
            // Validate that the loop ran exactly 11 times (from 0 to 10 inclusive)
            assert!(count == 11, 42);
        }
    }

    //# run
    /// This script tests referencing a function parameter by reference,
    /// then copying its value and modifying the original to see if the copy remains unchanged.
    script {
        fun test(p: u64): u64 {
            let _ref = &p; // reference to parameter
            let copy = p;   // copy of parameter
            // Simulate some operation on p
            let p_mut = p + 10;
            // The copy should remain unchanged
            copy
        }

        public fun main() {
            assert!(test(100) == 100, 43);
        }
    }

    //# run 0xabcde::range_tests::main
}