//# publish
module 0xA1B2::LogicalOperators {
    fun nested_logical_or() {
        // Test nested logical OR with true and false values
        assert!(true || false || false, 200);
        // Test precedence with nested logical AND inside OR
        assert!(false || (true && false), 201);
        // Test multiple ORs with true
        assert!(false || false || true, 202);
    }
}

//# run 0xA1B2::LogicalOperators::nested_logical_or

//# publish
module 0xA1B2::ComparisonOperators {
    fun complex_comparisons() {
        // Check combination of comparison and logical operators
        assert!((5 + 5) > 8 && (3 + 2) == 5, 210);
        // Test that comparison operators bind tighter than logical OR
        assert!((10 - 3) < 8 || (2 * 3) == 6, 211);
        // Check inequality with logical AND
        assert!(10 != 11 && 20 == 20, 212);
        // Ensure comparison with bitwise operators yields expected result
        assert!(((1 | 2) & 3) == 3, 213);
    }
}

//# run 0xA1B2::ComparisonOperators::complex_comparisons

//# publish
module 0xA1B2::BitwiseOperators {
    fun precedence_checks() {
        // Check precedence: XOR over OR
        assert!(1 | 3 ^ 1 == 3, 220);
        // Check AND over XOR
        assert!(2 ^ 3 & 1 == 3, 221);
        // Test combined bitwise with addition
        assert!((1 | 2) + 1 == 4, 222);
        // Check that AND binds tighter than addition
        assert!((2 & 3) + 4 == 6, 223);
    }
}

//# run 0xA1B2::BitwiseOperators::precedence_checks

//# publish
module 0xCDEF::InlineMutations {
    inline fun inc_and_double(x: &mut u64): u64 {
        *x = *x + 1;
        *x = *x * 2;
        *x
    }
    fun test_inc_and_double(): u64 {
        let mut val = 3;
        inc_and_double(&mut val)
    }
}

//# run 0xCDEF::InlineMutations::test_inc_and_double
