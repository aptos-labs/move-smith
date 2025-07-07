//# publish
module 0xabc::conditional_test {
    fun check_value(p: bool): u64 {
        if (p) {
            3
        } else {
            // When p is false, the function still should return 3
            3
        }
    }

    public fun main() {
        assert!(check_value(true) == 3, 0);
        assert!(check_value(false) == 3, 1);
    }
}

//# run 0xabc::conditional_test::main

//# publish
module 0xdef::lambda_arithmetic {
    // Inline lambdas to test parameter substitution and arithmetic operations
    inline fun compute(f:|u64, u64, u64| u64, g:|u64, u64, u64| u64, a: u64, b: u64, c: u64): u64 {
        let result1 = f(a, b, c);
        let result2 = g(a + 2, b + 3, c + 4);
        result1 + result2 + a + b + c
    }

    public fun test() {
        let res = compute(
            |x, y, z| x * y,
            |x, y, z| z - y,
            5, 10, 15
        );
        // Calculation:
        // f: 5 * 10 = 50
        // g: 15 - 10 = 5
        // sum: 50 + 5 + 5 + 10 + 15 = 85
        assert!(res == 85, res);
    }
}

//# run 0xdef::lambda_arithmetic::test