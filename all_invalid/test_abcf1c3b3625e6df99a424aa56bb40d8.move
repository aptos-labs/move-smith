//# publish
module 0xA::ConditionTest {
    // Function to test that it always returns 100 when condition is true,
    // regardless of other assignments.
    public fun test_return_true(): u64 {
        let x;
        if (true) {
            return 100;
        } else {
            x = 42;
        };
        x
    }

    // Runner function for direct invocation
    public fun run_test_return_true(): bool {
        let result = Self::test_return_true();
        // The expected result is 100
        // For the test, just return true if result equals 100
        result == 100
    }
}

//# run 0xA::ConditionTest::run_test_return_true
script {
    use 0xA::ConditionTest;

    fun main() {
        assert!(ConditionTest::run_test_return_true(), 101);
    }
}

//# publish
module 0xA::InteractionTest {
    // Function with nested if-else, testing the condition return behavior
    public fun complex_condition(input: bool): u64 {
        let val;
        if (input) {
            return 100;
        } else {
            if (input) {
                val = 0;
            } else {
                val = 999;
            }
        };
        val
    }

    // Runner without args to test the function with true input
    public fun run_true(): bool {
        let res = Self::complex_condition(true);
        res == 100
    }

    // Runner to test with false input
    public fun run_false(): bool {
        let res = Self::complex_condition(false);
        // Should be 999 regardless of the inner if
        res == 999
    }
}

//# run 0xA::InteractionTest::run_true
script {
    use 0xA::InteractionTest;

    fun main() {
        assert!(InteractionTest::run_true(), 102);
    }
}

//# run 0xA::InteractionTest::run_false
script {
    use 0xA::InteractionTest;

    fun main() {
        assert!(InteractionTest::run_false(), 103);
    }
}

//# publish
module 0xA::MultiBranch {
    // Function with multiple branches: only one branch returns 100.
    public fun multi_branch(cond1: bool, cond2: bool): u64 {
        if (cond1) {
            return 100;
        } else {
            if (cond2) {
                let x = 50;
                x
            } else {
                let y = 25;
                y
            }
        }
    }

    // Runner for case cond1 = true
    public fun run_cond1_true(): bool {
        let res = Self::multi_branch(true, false);
        res == 100
    }

    // Runner for case cond1 = false, cond2 = true
    public fun run_cond2_true(): bool {
        let res = Self::multi_branch(false, true);
        res == 50
    }

    // Runner for case cond1 = false, cond2 = false
    public fun run_both_false(): bool {
        let res = Self::multi_branch(false, false);
        res == 25
    }
}

//# run 0xA::MultiBranch::run_cond1_true
script {
    use 0xA::MultiBranch;

    fun main() {
        assert!(MultiBranch::run_cond1_true(), 104);
    }
}

//# run 0xA::MultiBranch::run_cond2_true
script {
    use 0xA::MultiBranch;

    fun main() {
        assert!(MultiBranch::run_cond2_true(), 105);
    }
}

//# run 0xA::MultiBranch::run_both_false
script {
    use 0xA::MultiBranch;

    fun main() {
        assert!(MultiBranch::run_both_false(), 106);
    }
}