//# publish
module 0xabcde::conditional_tests {
    public fun compute_sum(p: bool): u64 {
        let mut x = 10;
        if (p) {
            x = x + 5;
        } else {
            x = x + 15;
        }

        let mut y = 20;
        if (!p) {
            y = y + 10;
        } else {
            y = y + 20;
        }

        let mut z = 0;
        if (p) {
            z = x + y;
        } else {
            z = y - x;
        }

        // Return the sum of all three variables
        x + y + z
    }

    // Additional function to test nested conditionals and reassignments
    public fun nested_test(p: bool): u64 {
        let a = 1;
        let b = if (p) {
            let a = a + 2;
            a + 3
        } else {
            a + 4
        };

        let c = if (b > 5) {
            let c = b * 2;
            c - 1
        } else {
            b * 3
        };

        if (p) {
            // reassign a
            let a = a + c;
        }

        a + b + c
    }
}

//# run 0xabcde::conditional_tests::compute_sum --args true

//# run 0xabcde::conditional_tests::compute_sum --args false

//# run 0xabcde::conditional_tests::nested_test --args true

//# run 0xabcde::conditional_tests::nested_test --args false