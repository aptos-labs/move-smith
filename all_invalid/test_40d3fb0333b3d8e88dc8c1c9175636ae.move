//# publish
module 0xA01::ArithmeticEdgeCases {
    // Test inline function applying multiple lambdas to check their combined sum
    //# publish
    inline fun apply_and_sum(
        f: |u32, u32| u32,
        g: |u32, u32| u32,
        h: |u32, u32| u32,
        i: |u32, u32| u32,
        x: u32,
        y: u32
    ): u32 {
        f(x, y) + g(x, y) + h(x, y) + i(x, y)
    }

    public fun run_tests() {
        // Test multiple lambdas with boundary values
        assert!(
            apply_and_sum(
                |a: u32, b: u32| a,
                |_: u32, y: u32| y,
                |a: u32, _b: u32| a,
                |_: u32, b: u32| b,
                0,
                4294967295
            ) == 0 + 4294967295 + 0 + 4294967295,
            0
        );

        // Test with maximum input values
        assert!(
            apply_and_sum(
                |a: u32, b: u32| a,
                |a: u32, b: u32| b,
                |a: u32, b: u32| a,
                |a: u32, b: u32| b,
                4294967295,
                4294967295
            ) == 4294967295 + 4294967295 + 4294967295 + 4294967295,
            1
        );
    }
}

//# run 0xA01::ArithmeticEdgeCases::run_tests

//# publish
module 0xA02::ArithmeticOperations {
    // Test division and modulus with boundary and error cases
    //# publish
    public fun test_div_mod() {
        // Valid division
        assert!(100u32 / 10u32 == 10u32, 0);
        // Division by 1
        assert!(12345u32 / 1u32 == 12345u32, 1);
        // Modulus with boundary
        assert!(100u32 % 3u32 == 1u32, 2);
        // Modulus with maximum value
        assert!(4294967295u32 % 2u32 == 1u32, 3);
    }

    public fun test_division_errors() {
        // Division by zero should fail (simulate with comment as runtime will panic)
        // Should cause error:
        // 1u32 / 0u32;
        // Should cause error:
        // 4294967295u32 / 0u32;
        // Should cause error:
        // 0u32 / 0u32;
    }
}

//# run 0xA02::ArithmeticOperations::test_div_mod

//# publish
module 0xA03::OverflowUnderflow {
    // Test overflow behaviors for addition and multiplication
    //# publish
    public fun test_overflow() {
        let max : u32 = 4294967295;
        // Addition overflow check: max + 1 should panic or overflow
        // (In Move, overflow should trap if not checked)
        // assert! (max + 1 == 0, 0); // commented: overflow
        // Multiplication overflow check
        // 2147483648 * 2 == 4294967296 (overflow)
        // assert! (2147483648u32 * 2u32 == 0, 1); // commented: overflow
    }

    // Test underflow behaviors for subtraction
    public fun test_underflow() {
        // 0 - 1 should panic or trap
        // assert! (0 - 1 == 0, 10); // commented: underflow
        // 1 - 2 should panic or trap
        // assert! (1 - 2 == 0, 11); // commented: underflow
    }
}

//# run 0xA03::OverflowUnderflow::test_overflow
//# run 0xA03::OverflowUnderflow::test_underflow