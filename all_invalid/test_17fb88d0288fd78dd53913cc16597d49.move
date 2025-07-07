//# publish
module 0x123::InlineFunctionTest {
    // Define an inline function that takes four lambdas and two input values
    inline fun apply_lambdas(
        a:|u64, b:|u64, 
        c:|u64, d:|u64, 
        x: u64, y: u64
    ): u64 {
        a(x, y) + b(x, y) + c(x, y) + d(x, y)
    }

    // Public function to test applying various lambdas with different behaviors
    public fun run_test() {
        // Define lambdas with different logic
        let sum_x = |x: u64, _: u64| { x };
        let sum_y = |_x: u64, y: u64| { y };
        let double_x = |x: u64, _: u64| { x * 2 };
        let triple_y = |_x: u64, y: u64| { y * 3 };

        // Call apply_lambdas with the lambdas and inputs
        let result = apply_lambdas(
            sum_x, 
            sum_y, 
            double_x, 
            triple_y, 
            7, 
            5
        );

        // The expected result calculation:
        // sum_x(7,5) = 7
        // sum_y(7,5) = 5
        // double_x(7,5) = 14
        // triple_y(7,5) = 15
        // Total = 7 + 5 + 14 + 15 = 41
        
        assert!(result == 41, 0);
    }
}

//# run 0x123::InlineFunctionTest::run_test