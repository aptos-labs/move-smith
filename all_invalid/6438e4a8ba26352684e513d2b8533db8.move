//# publish
module 0xCAFE::LoopAndSpecTest {
    use std::vector;

    // A spec function to check if a number is even
    spec fun is_even(x: u64): bool {
        x % 2 == 0
    }

    // A spec function that returns the sum of first n natural numbers
    spec fun sum_n(n: u64): u64 {
        if (n == 0) {
            0
        } else {
            n + sum_n(n - 1)
        }
    }

    // A function that uses nested while loops and reassignment of variables
    public fun nested_while_and_reassign(n: u64): u64 {
        let mut sum: u64 = 0;
        let mut i: u64 = 0;

        // Outer loop: increase i until n
        while (i < n) {
            let mut j: u64 = 0;

            // Inner loop: increase j until i
            while (j < i) {
                sum = sum + j;
                j = j + 1;
            };

            // Reassign i
            i = i + 1;
        };
        sum
    }

    // A function that tests variable reassignment multiple times
    public fun var_reassign_test(x: u64): u64 {
        let mut val: u64 = x;

        val = val + 1;
        val = val * 2;
        val = val - 3;
        val
    }

    // Runner function that exercises the above functions without arguments
    public fun runner() {
        let _ = nested_while_and_reassign(5);
        let _ = var_reassign_test(10);
    }
}

//# run 0xCAFE::LoopAndSpecTest::nested_while_and_reassign --args 5u64

//# run 0xCAFE::LoopAndSpecTest::var_reassign_test --args 10u64

//# run 0xCAFE::LoopAndSpecTest::runner

// Features:
// b0977166124a342053b03544cc9b5b39: Use 'while' loops with condition expressions and nested control sequences.
// 0b6f2742d8864af5077463340b1d65fc: Define specification functions (spec fun) to encapsulate logic used in specifications and verification conditions.
// 1418e667301691482936c74e8131da72: Test that variable reassignment works correctly within a function body.