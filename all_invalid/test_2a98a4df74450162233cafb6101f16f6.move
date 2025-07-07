//# publish
module 0x1234::nesting_tests {
    // Helper struct with a field to test struct-like modifications
    struct Counter has copy, drop {
        value: u64,
    }

    // Function to create a new Counter
    public fun new_counter(init: u64): Counter {
        Counter { value: init }
    }

    // Function to increment Counter in-place
    public fun incr(counter: &mut Counter): u64 {
        counter.value = counter.value + 1;
        counter.value
    }

    // Function to test variable renaming and reassignment within nested expressions
    public fun test_renaming_reassignment(): u64 {
        let a = 10;
        let result = {
            // Rename 'a' to 'b' within nested expression
            let b = a;
            // Reassign b
            { b = b + 5; b } + { b = b + 3; b }
        };
        result
    }

    // Function to test inline modifications within struct expressions
    public fun test_struct_modifications(): u64 {
        let counter = new_counter(0);
        let total = {
            // Increment counter and assign to temp
            let temp_counter = &mut counter;
            let first = {
                incr(temp_counter)
            };
            // Increment again
            let second = incr(temp_counter);
            // Final sum
            first + second
        };
        total
    }

    // Function to run nested variable updates and struct-like modifications in sequence
    public fun run_tests(): (u64, u64) {
        let r1 = test_renaming_reassignment();
        let r2 = test_struct_modifications();
        (r1, r2)
    }
}

//# run 0x1234::nesting_tests::run_tests --signers 0x1 --args

//# publish
module 0x5678::edge_case_tests {
    // Function to test 128-bit arithmetic edge cases with custom behavior
    public fun test_overflow_add(): u128 {
        // Try adding the max value (overflow should fail)
        340282366920938463463374607431768211455u128 + 1u128
    }

    public fun test_underflow_sub(): u128 {
        // Subtract 1 from 0 (should panic or fail)
        0u128 - 1u128
    }

    public fun test_mul_overflow(): u128 {
        // Multiplying large values to cause overflow
        18446744073709551615u128 * 2u128
    }

    public fun test_division_by_zero(): u128 {
        // Division by zero should fail
        123u128 / 0u128
    }

    public fun test_modulo_by_zero(): u128 {
        // Modulo by zero should fail
        123u128 % 0u128
    }

    // Function to run all edge case tests
    public fun run_edge_cases(): (u128, u128, u128) {
        let sum_overflow = test_overflow_add();
        let underflow = test_underflow_sub();
        let product_overflow = test_mul_overflow();
        (sum_overflow, underflow, product_overflow)
    }
}

//# run 0x5678::edge_case_tests::run_edge_cases --signers 0x2

//# publish
module 0x9abc::nested_source_test {
    // Function to test nested expressions with variable reassignments
    public fun test_nested_exprs(): u64 {
        let mut x = 5;
        // Reassign x inside nested expressions and use it multiple times
        {x = x * 2; x} + {x = x + 3; x}
    }

    // Function to test function calls with inline modifications
    public fun test_function_calls(): u64 {
        let mut counter = 0;
        public fun incr_counter(): u64 {
            counter = counter + 1;
            counter
        }
        // Call incr_counter multiple times inside add
        incr_counter() + incr_counter() + incr_counter()
    }

    // Function to execute all tests
    public fun run_all(): (u64, u64) {
        (test_nested_exprs(), test_function_calls())
    }
}

//# run 0x9abc::nested_source_test::run_all --signers 0x3
