//# publish
module 0x42::ArithmeticLambdaTest {
    // Test inline lambdas for parameter substitution and arithmetic correctness

    // Define an inline lambda that performs arithmetic on parameters
    inline fun compute(f:|u64, u64, u64| u64, g:|u64, u64, u64| u64, a: u64, b: u64, c: u64): u64 {
        let res_f = f({x = a * 2; a}, {x = b + 3; b}, {x = c - 1; c});
        let res_g = g({x = a + 4; a}, {x = b * 2; b}, {x = c + 5; c});
        // Final computation combines results
        res_f + res_g + a + b + c
    }

    public fun test() {
        // Call compute with specific functions and parameters
        let result = compute(
            |x, y, z| x * y + z,            // first lambda: multiply first two params then add third
            |x, y, z| y - z,                // second lambda: subtract z from y
            3, 4, 5                        // inputs a=3, b=4, c=5
        );
        // Expected calculation:
        // res_f = (a*2)*(b+3) + c-1 = (3*2)*(4+3) + 5-1 = 6*7 + 4 = 42 + 4 = 46
        // res_g = (a+4)* (b*2) + c+5 = (3+4)*8 + 5+5 = 7*8 + 10 = 56 + 10 = 66
        // Final result = 46 + 66 + 3 + 4 + 5 = 124
        assert!(result == 124, result);
    }
}

//# run 0x42::ArithmeticLambdaTest::test