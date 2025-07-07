script {
    fun main() {
        // 1. Test unreachable code after return
        {
            // Return early from the inner block
            return;
            // The following code is unreachable and should not cause assertion failures
            assert!(false, 1);
        }

        // 2. Test for-loop with break, continue, and conditional modifications
        let mut sum = 0;
        let limit = 10;
        let break_at = 7;

        let i = 0;
        while (i < limit) {
            let current = i;

            // Skip even numbers
            if (current % 2 == 0) {
                i = i + 1;
                continue;
            }

            // Break loop if current number equals break_at
            if (current == break_at) {
                break;
            }

            // Add current odd number to sum
            sum = sum + current;

            i = i + 1;
        }

        // Expected sum:
        // Odd numbers less than 7 are: 1,3,5
        // sum = 9
        assert!(sum == 9, 2);

        // 3. Group multiple expressions in a block
        let result = {
            let a = 3;
            let b = 4;
            let c = a * b;
            c + 5  // last expression is the value of the block
        };

        assert!(result == 17, 3);
    }
}

// Featurres:
// b5c3260276f2028e7b0be092265f351d: Test that code after a return statement is unreachable and does not cause assertion failures.
// cdd89ec6201f63d1f00c83114f52bb19: Test that the Move script correctly handles the combination of for-loop iteration, break, continue, and conditional modifications to a variable, resulting in the expected final value.
// bd0d82d62d8269d2a5bd834f8a8fa85e: Group multiple expressions into a block with the `block` expression.
