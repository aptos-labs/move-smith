//# publish
module 0xCAFE::TupleTest {
    /// A simple struct to help test return values and tuple destructuring
    struct Pair has copy, drop, store {
        x: u64,
        y: u64,
    }

    /// Returns a tuple of 3 integers
    public fun get_three_numbers(): (u64, u64, u64) {
        (1u64, 2u64, 3u64)
    }

    /// Returns Pair and a u64 together
    public fun get_pair_and_single(): (Pair, u64) {
        (Pair { x: 10u64, y: 20u64 }, 30u64)
    }

    /// Tests multiple reassignment and combining variables
    /// Reassigns local variables multiple times
    public fun runner() {
        // destructure a triple tuple
        let (a, b, c) = Self::get_three_numbers();
        let sum = a + b + c;

        // destructure a pair and a single int
        let (p, d) = Self::get_pair_and_single();

        // reassign local variables
        let mut val = sum;
        val = val + p.x;
        val = val + p.y;
        val = val + d;

        // Just return nothing, no assertion needed
    }
}
//# run 0xCAFE::TupleTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::TupleTest;

    fun main() {
        // Destructure a tuple returned from function
        let (x, y, z) = TupleTest::get_three_numbers();

        let mut total = x + y;
        total = total + z;

        let (pair, num) = TupleTest::get_pair_and_single();

        // Reassign the total combining the fields from struct pair and num
        total = total + pair.x + pair.y + num;

        // No assertions, just let it run to test compiler and VM
    }
}

// Featurres:
// 71f6838867cd49cfda14b3b0fd4c527d: Verify an individual compiled unit for correctness.
// fd5e5aee0e1fe660bee184852c41b5dd: Destructure tuples or multiple return values into multiple variables in a single let statement.
// 2667e69d7820eeec54a254cf0e7dad45: Test that a local variable can be reassigned and that its value combines correctly with another variable in the function.
