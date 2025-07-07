//# publish
module 0xA1::InlineFunctionsTest {
    // Define inline functions to be passed as arguments to 'foo'
    inline fun double(x: u64): u64 {
        x * 2
    }

    inline fun triple(x: u64): u64 {
        x * 3
    }

    // The 'foo' function takes two inline functions and an input, applies each to input, and sums their results
    fun foo(f: |u64| u64, g: |u64| u64, x: u64): u64 {
        f(x) + g(x)
    }

    // A runner function to test passing inline functions as arguments
    public fun run_tests() {
        let result1 = foo(double, triple, 5);
        // For demonstration, you can assert or log the result if needed
        // e.g., assert!(result1 == (5 * 2) + (5 * 3), 0);
        // Alternatively, return result for visibility (not part of assertions as per instructions)
        // return result1;
    }
}

//# run 0xA1::InlineFunctionsTest::run_tests