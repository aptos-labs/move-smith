//# publish
module 0xABC::early_return_test {
    fun check_condition(): bool {
        // Simulate some condition
        true
    }

    public fun main() {
        let mut flag = false;
        if (check_condition()) {
            // Early return if condition is true
            return;
        } else {
            flag = true;
        };
        // The following assertion should not be triggered if early return works
        assert!(flag, 99);
    }
}

//# run 0xABC::early_return_test::main

//# publish
module 0xDEF::sum_and_check {
    fun compute_sum(): u64 {
        let a = 1;
        let b = 1;
        let c = 2;
        // Sum all local variables
        a + b + c
    }

    public fun main() {
        let total = compute_sum();
        // Assert that total sums to 4
        assert!(total == 4, 100);
    }
}

//# run 0xDEF::sum_and_check::main

//# publish
module 0x123::multi_return {
    fun early_return_condition(): bool {
        false
    }

    fun compute_value(): u64 {
        // This function should run only if no early return
        7
    }

    public fun main() {
        let result;
        if (early_return_condition()) {
            // Early return prevents the rest of main from executing
            return;
        } else {
            result = compute_value();
        }
        // This assertion should execute if no early return
        assert!(result == 7, 101);
    }
}

//# run 0x123::multi_return::main