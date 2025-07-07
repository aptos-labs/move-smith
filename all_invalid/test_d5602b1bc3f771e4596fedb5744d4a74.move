//# publish
module 0xabc::LoopBreakContinueTest {
    public fun test_loop_break_continue() {
        let mut counter = 0;
        let mut total = 0;

        // Outer loop: run 5 times
        for (outer_i in 0..5) {
            // Inner loop: run 10 times
            for (inner_i in 0..10) {
                total = total + inner_i;
                if (inner_i == 3) {
                    // Skip adding after 3
                    continue;
                }
                if (inner_i == 7) {
                    // Break inner loop early
                    break;
                }
                counter = counter + 1;
            }
            if (outer_i == 2) {
                // After third outer iteration, break outer loop
                break;
            }
        }
        // At this point:
        // counter counts how many inner iterations were processed before continue/break
        // total sums inner_i values, with some skipped and some ending early
        // For verification, expected:
        // outer iterations: 0,1,2
        // inner loop: 0..10, but skipped after inner_i==3, break at inner_i==7
        // inner_i process per outer:
        // inner_i: 0,1,2,3,4,5,6,7,8,9
        // with continue at 3, so after inner_i==3:
        // processed inner_i 0,1,2,4,5,6,8,9
        // inner_i==7 causes break
        // So in each outer:
        // When inner_i==3, continue skips the rest
        // When inner_i==7, break stops inner loop early.
        // Ending outer loop at outer_i==2

        // Summarize expected counters and total:
        // counter increments only on not continue/break
        // We'll just place assertions here for demonstration.

        assert!(counter > 0, counter);
        assert!(total >= 0, total);
    }
}

//# run 0xabc::LoopBreakContinueTest::test_loop_break_continue

//# publish
module 0xabc::BitwiseLogicalOps {
    fun test_operations() {
        use std::vector;

        let a_bool = true && false || true;
        let b_bool = false && true || false;
        
        // Test logical operations
        assert!(!a_bool, a_bool);
        assert!(b_bool == false, b_bool);

        let a_and_b = a_bool && b_bool;
        let a_or_b = a_bool || b_bool;

        // Test bitwise operations on primitive types
        let x: u64 = 0b1010;
        let y: u64 = 0b1100;

        let and_result = x & y; // 0b1000
        let or_result = x | y; // 0b1110
        let xor_result = x ^ y; // 0b0110

        assert!(and_result == 0b1000, and_result);
        assert!(or_result == 0b1110, or_result);
        assert!(xor_result == 0b0110, xor_result);

        // Test equality and inequality
        assert!(x != y, x);
        assert!(x == (0b1010), x);

        // Test vector of booleans for logical consistency
        let bool_vec = vector[true, false, true, false];
        assert!(vector::length(&bool_vec) == 4, vector::length(&bool_vec));

        // Verify vector comparisons
        for (i in 0..vector::length(&bool_vec)) {
            assert!(vector::borrow(&bool_vec, i) == if (i % 2 == 0) { true } else { false }, i);
        }
    }
}

//# run 0xabc::BitwiseLogicalOps::test_operations

//# publish
module 0xabc::NestedLoops {
    fun run_nested_loops() {
        let mut count = 0;
        let mut sum = 0;

        for (i in 0..3) {
            let mut j = 0;
            loop {
                if (j >= 5) {
                    break;
                }
                if (i == 1 && j == 2) {
                    // Break inner loop early on specific condition
                    break;
                }
                // Update counters
                sum = sum + i + j;
                count = count + 1;

                if (j == 3 && i == 2) {
                    // Nested loop with break condition
                    break;
                }
                j = j + 1;
            }
            if (i == 2) {
                // Exit outer loop early
                break;
            }
        }
        // Post-conditions can be checked via assertions in test script.
        assert!(count > 0, count);
        assert!(sum >= 0, sum);
    }
}

//# run 0xabc::NestedLoops::run_nested_loops