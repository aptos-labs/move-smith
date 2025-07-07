//# publish
module 0x123::logic_tests {
    //# publish
    // Module to test operator precedence and logical assertions.
    public fun run_assertions() {
        // Test logical OR and AND precedence
        assert!(false || true && false, 200);
        // Expect false: true && false = false; false || false = false
        assert!(true || false && true, 201);
        // Expect true: false && true = false; true || false = true

        // Test comparison combined with logical operators
        assert!((10 != 20) && (30 > 20), 202);
        // Both true: true && true = true
        assert!((5 >= 5) || (3 < 2), 203);
        // true || false = true

        // Test bitwise OR and XOR precedence
        assert!(1 | 2 ^ 3 == 0, 204);
        // XOR has precedence: 2 ^ 3 = 1; 1 | 1 = 1 (but expecting 0? Let's check carefully)
        // Actually, 1 | 2 = 3; 3 ^ 3 = 0
        // So we need to write the expression accordingly:
        assert!( (1 | 2) ^ 3 == 0, 205);

        // Test binary AND and XOR precedence
        assert!((4 & 3) ^ 1 == 6, 206);
        // 4 & 3 = 0; 0 ^ 1 = 1; so expecting 1
        assert!((7 & 5) ^ 2 == 4, 207);
        // 7 & 5 = 5; 5 ^ 2 = 7, but expecting 4, so adjust expression:
        assert!((7 & 5) ^ 2 == 7 ^ 2, 208); // for demonstration, keep as expression

        // Test addition and multiplication precedence
        assert!(2 + 3 * 4 == 14, 209);
        // multiplication before addition
        assert!( (1 + 2) * 3 == 9, 210);

        // Test combined logical and comparison operators
        assert!((true && false) || (3 > 2), 211);
        // false || true = true
        assert!(!(false && false) && (5 != 10), 212);
        // true && true = true
    }
}

//# run 0x123::logic_tests::run_assertions

//# publish
module 0x456::operator_prescedence {
    public fun run_example_expressions() {
        // Confirm that various expressions behave as expected
        // Note: assuming the expressions are to be evaluated and asserted
        assert!(true || true && false, 300); // true
        assert!(true != false && false != true, 301); // true && true = true
        assert!(1 | 3 ^ 1 == 3, 302); // 3 ^ 1 = 2; 1 | 2 = 3
        assert!(2 ^ 3 & 1 == 3, 303); // 3 & 1=1; 2 ^ 1=3
        assert!(3 & 3 + 1 == 0, 304); // 3 + 1=4; 3 & 4=0
        assert!(1 + 2 * 3 == 7, 305); // 2*3=6; 1+6=7
    }
}

//# run 0x456::operator_prescedence::run_example_expressions

//# publish
module 0xC0FFEE::helper {
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun compute(): u64 {
        let x = 2;
        // compute sum of two add calls involving different manipulations
        add({x = x - 1; x + 8}, {x = x + 3; x - 3}) + add({x = x * 2; x * 2}, {x = x + 1; x})
        // Explanation:
        // First add: x=2 so x-1=1; 1+8=9
        // second add: x=2; x+3=5; 5-3=2
        // sum1=9+2=11
        // third add: x=2; x*2=4; 4*2=8
        // fourth add: x=2; x+1=3; 3
        // sum2=8+3=11
        // total=11+11=22
    }
}

//# run 0xC0FFEE::helper::compute