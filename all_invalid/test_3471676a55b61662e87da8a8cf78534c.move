//# publish
module 0xA1B2::LogicalOperatorsTest {

    public fun test_logical_operations(): bool {
        // Test AND operation correctness
        let and_result = true && false;
        assert!(!and_result, 200);

        // Test OR operation correctness
        let or_result = false || true;
        assert!(or_result, 201);

        // Test NOT operation
        let not_true = !true;
        let not_false = !false;
        assert!(!not_true, 202);
        assert!(not_false, 203);

        // Test double negation
        let double_not_true = !!true;
        let double_not_false = !!false;
        assert!(double_not_true, 204);
        assert!(!double_not_false, 205);

        // Further complex logical expression
        let complex_expr = (true && (false || !false)) && !!true;
        assert!(complex_expr, 206);

        false
    }

    public fun run_logical_ops(): bool {
        test_logical_operations()
    }
}

//# run 0xA1B2::LogicalOperatorsTest::run_logical_ops

//# publish
module 0xC3D4::AddFunctionTest {

    public fun add_two_numbers(x: u64, y: u64): u64 {
        x + y
    }

    public fun test(): u64 {
        let sum = add_two_numbers(1, 2);
        sum
    }

    public fun check_sum(): u64 {
        // Call the test function to verify it returns the correct sum
        test()
    }
}

//# run 0xC3D4::AddFunctionTest::check_sum --signers 0x0000000000000000 --args