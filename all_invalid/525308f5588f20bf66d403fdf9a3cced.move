
//# publish
module 0xCAFE::LoopTest {
    use std::vector;

    /// This function takes a vector of u64 and returns the sum of all elements using a for-each style loop.
    public fun foreach_sum(v: vector<u64>): u64 {
        let sum = 0u64;
        for (elem in &v) {
            sum = sum + *elem;
        };
        sum
    }

    /// This function increments `start` by 1 until it reaches `limit`.
    /// It uses continue to skip when the counter is 5 (so 5 is not added to the total).
    /// The loop breaks when the counter is greater than or equal to the limit.
    public fun while_loop_with_break_continue(start: u64, limit: u64): u64 {
        let count = start;
        let total = 0u64;
        while (true) {
            if (count >= limit) {
                break;
            };
            if (count == 5) {
                count = count + 1;
                continue;
            };
            total = total + count;
            count = count + 1;
        };
        total
    }

    /// This function triggers an arithmetic error by overflowing u8.
    // expected_failure(arithmetic_error)]
    public fun overflow_u8() {
        let x: u8 = 255;
        let _ = x + 1;
    }
}


//# run 0xCAFE::LoopTest::foreach_sum --args vector[1u64, 2u64, 3u64, 4u64]


//# run 0xCAFE::LoopTest::while_loop_with_break_continue --args 0u64 10u64


//# run 0xCAFE::LoopTest::overflow_u8


// Featurres:
// 6429218e3e29ce1b963e2bcaa3f3a253: Test that the `foreach` function correctly iterates over a vector and computes the sum of its elements.
// d10f9df330268b61315c1c021eeb081d: Test that the while loop correctly handles the use of both break and continue statements to increment a variable until it reaches a specific value.
// 20294188ec76665b821ef7c9560d065a: Indicate an arithmetic error expected in your test with `#[expected_failure(arithmetic_error)]` attribute.
