//# publish
module 0xAABBCC::nested_control_flow {
    public fun test_loops(): () {
        // Initialize variables
        let mut sum = 0;
        let mut product = 1;

        // Outer for loop: iterate 3 times
        for (i in 0..3) {
            sum = sum + i;

            // Inner while loop: run while sum < 10
            while (sum < 10) {
                sum = sum + 2;
                if (sum > 10) {
                    break;
                }
            };

            // Nested for loop inside outer loop
            for (j in 0..2) {
                product = product * (i + j + 1);
            }
        };

        // Another while with nested for
        let mut k = 0;
        while (k < 4) {
            for (m in 0..k+1) {
                sum = sum + m;
            };
            k = k + 1;
        };

        // Final assertions (not enforced, just to simulate validation)
        // The variables should reflect the nested control flow execution
        // For example, sum might be 10 or more, product accumulated accordingly.
        // (Assertions are omitted as per instructions)
    }
}

//# run 0xAABBCC::nested_control_flow::test_loops

//# publish
module 0xDDEEFF::variable_rename {
    public fun test_rename_and_reassign(): u64 {
        let mut a = 5;
        let mut b = a;
        b = b + 10;   // b gets updated
        let c = b;    // c takes the value of b

        // Using nested expressions with renaming
        let result = {
            let (d, e) = (c, 2 + c);
            // d and e are new names for c and expression
            d * e
        };

        // Re-assign c based on result
        let c = result;

        c // Return c to verify final value (not to assert, just for flow)
    }
}

//# run 0xDDEEFF::variable_rename::test_rename_and_reassign