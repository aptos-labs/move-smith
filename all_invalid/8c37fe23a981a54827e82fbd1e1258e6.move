module 0x1::transactional_test {

    struct DummyStruct has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
        d: u8,
        e: u8,
    }

    public fun test_loop_and_while() {
        // Loop expression test with break
        let mut i = 0;
        let mut sum = 0;
        loop {
            // add i to sum
            sum = sum + i;
            i = i + 1;
            if (i == 10) {
                break;
            }
        }
        assert!(sum == 45, 1); // 0+1+...+9=45

        // While loop test
        let mut j = 10;
        let mut product = 1;
        while (j > 0) {
            product = product * j;
            j = j - 1;
        }
        assert!(product == 3628800, 2); // 10!
    }

    public fun test_operator_precedence() {
        // Operators to test: '==', '!=', '<', '>',
        // '<=', '>=', '||', '&&', '|', '^', '&',
        // '<<', '>>', '+', '-', '*', '/', '%'

        // We'll create expressions where precedence is critical
        // and verify the evaluated results match expected values.

        // Arithmetic operations
        let a = 10;
        let b = 3;
        let mut val = 0;

        // '*' and '/' and '%' have higher precedence than '+' and '-'
        val = 1 + 2 * 3; // expect 7
        assert!(val == 7, 3);

        val = 10 - 6 / 2; // 10 - 3 = 7
        assert!(val == 7, 4);

        val = (10 - 6) / 2; // we enforce parentheses to test
        assert!(val == 2, 5);

        val = 20 % 6 + 1; // (20%6)=2 + 1 =3
        assert!(val == 3, 6);

        // Shift operators have lower precedence than + and -
        val = 1 + 2 << 3; // (1 + 2) << 3 = 3 << 3 = 24
        assert!(val == 24, 7);

        val = 1 + (2 << 3); // 1 + (16) = 17
        assert!(val == 17, 8);

        // Bitwise operators: '&', '^', '|'
        val = 1 | 2 & 3; 
        // '&' has higher precedence than '|'
        // So val = 1 | (2 & 3) = 1 | 2 = 3
        assert!(val == 3, 9);

        val = (1 | 2) & 2; // (3) & 2 = 2
        assert!(val == 2, 10);

        val = 1 ^ 2 | 4 & 7;
        // & has higher precedence than |, which has higher than ^
        // So: 1 ^ (2 | (4 & 7)) 
        // 4 & 7 = 4
        // 2 | 4 = 6
        // 1 ^ 6 = 7
        assert!(val == 7, 11);

        // Comparison operators: '==', '!=', '<', '>', '<=', '>='
        let x = 5;
        let y = 10;
        assert!(x < y, 12);
        assert!(y >= x, 13);
        assert!(x != y, 14);
        assert!(!(x == y), 15);

        // Logical operators: '&&', '||'
        let b1 = true;
        let b2 = false;
        // '&&' has higher precedence than '||'
        assert!((b1 || b2) && b1, 16);
        assert!(b1 || b2 && false == true, 17);
        // This is: b1 || (b2 && false)
        assert!(b1 || (b2 && false), 18);

        // Combine multiple operators in one expression:
        // Check which operators bind stronger
        val = 1 + 2 * 3 < 10 && (5 | 2) == 7 || false;
        // Step by step:
        // 2 * 3 = 6
        // 1 + 6 = 7
        // 7 < 10 = true
        // 5 | 2 = 7
        // 7 == 7 = true
        // true && true = true
        // true || false = true
        assert!(val, 19);
    }

    public fun test_dotdot_pattern_matching() {
        // Create a dummy struct instance
        let instance = DummyStruct { a: 1, b: 2, c: 3, d: 4, e: 5 };

        // Use pattern with .. syntax to match only some fields, ignore rest
        match instance {
            DummyStruct { a: x, b: y, .. } => {
                // x should be 1, y should be 2
                assert!(x == 1, 20);
                assert!(y == 2, 21);
            }
        }

        // Also use .. alone to ignore all fields (pattern useless but syntactically valid)
        match instance {
            DummyStruct { .. } => {
                // Always true, just test that this compiles and runs
                assert!(true, 22);
            }
        }
    }

    #[test_only]
    public fun run_all_tests() {
        test_loop_and_while();
        test_operator_precedence();
        test_dotdot_pattern_matching();
    }
}

// Featurres:
// f96cc4f30b7f686ed09564d26da154d2: Create loops with `While` and `Loop` expressions.
// 115fee4aaa6657a698e8acb005e52c16: Identify the precedence level of operators like '==', '!=', '<', '>', '<=', '>=', '||', '&&', '|', '^', '&', '<<', '>>', '+', '-', '*', '/', and '%' in Move code.
// a56262b170f67b534296aa6ded7843c2: Use '..' (dotdot) syntax in pattern matching to ignore the remaining fields of a struct.
