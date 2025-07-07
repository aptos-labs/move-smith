//# publish
module 0xA11CE::LogicTest {
    public fun evaluate_conditions(): bool {
        // Check combined boolean expressions with nested if conditions
        let result = (true && (if (false) false else (3 + 2 > 4))) || (if (false) true else (10 - 5 == 5));
        // Expected: (true && (3 + 2 > 4)) || (true) => (true && true) || true => true || true => true
        assert!(result, 0);
        result
    }

    public fun assign_and_assert(): bool {
        // Use conditional expression in assignment
        let val = if (true) {
            100
        } else {
            200
        };
        // validate assignment
        assert!(val == 100, 1);

        // Use nested conditionals and boolean logic to assign
        let another_val = if ((false && true) || (3 > 2)) {
            50
        } else {
            25
        };
        // Expected: if (false && true) || true => false || true => true, so assign 50
        assert!(another_val == 50, 2);

        // Return true for passing checks
        true
    }

    public fun complex_boolean_evaluation(n: u64): bool {
        // Combine multiple boolean conditions with numeric comparisons
        let result = ((n % 2 == 0) && (n > 10)) || (!(n < 5));
        // For n = 12: (true && true) || true => true
        // For n = 3: (false && false) || true => true
        // For n = 7: (false && true) || false => false
        result
    }
}

//# run 0xA11CE::LogicTest::evaluate_conditions
//# run 0xA11CE::LogicTest::assign_and_assert
//# run 0xA11CE::LogicTest::complex_boolean_evaluation --args 12