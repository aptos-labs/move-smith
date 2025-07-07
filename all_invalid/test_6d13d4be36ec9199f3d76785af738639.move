//# publish
module 0xabcde::test_module {
    public fun compute_value(): u64 {
        let a = 10;
        let b = 20;
        let c = 30;

        let result = {
            let mut temp = a;
            {
                temp = temp + b;
            }
            let mut temp2 = temp;
            {
                temp2 = temp2 + c;
            }
            temp2
        };

        result
    }

    public fun run_nested_mutability_test(): u64 {
        let total = 0;
        let x = 5;

        // Nested blocks updating x
        let total = {
            let mut inner_x = x;
            {
                inner_x = inner_x + 10;
            }
            inner_x + 1 // should be 16 if inner_x updated correctly
        };

        // Further nested block with more modifications
        let total = {
            let mut y = total; // 16
            {
                y = y + 4;
            }
            y
        };

        total
    }

    public fun test_early_return_in_loop(): bool {
        let mut sum = 0;
        let limit = 10;

        while (sum < limit) {
            if (sum == 5) {
                return true;  // Early return inside loop
            }
            sum = sum + 1;
        }

        // Prevent code after loop from executing if early return works
        assert!(false, 999);
        false
    }

    // Runner function for the nested mutability test
    public fun run_nested_mutability(): u64 {
        compute_value()
    }

    // Runner function for early return test
    public fun run_early_return_test(): bool {
        test_early_return_in_loop()
    }
}

//# run 0xabcde::test_module::run_nested_mutability
//# run 0xabcde::test_module::run_early_return_test