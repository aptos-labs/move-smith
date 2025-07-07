//# publish
module 0xCAFE::ArithmeticTests {
    public fun test_division(a: u64, b: u64) {
        // We avoid dividing by zero to prevent runtime failure.
        if (b != 0) {
            let _ = a / b;
        }
    }

    public fun test_modulo(a: u64, b: u64) {
        // We avoid modulo by zero to prevent runtime failure.
        if (b != 0) {
            let _ = a % b;
        }
    }
    
    // A runner function to test division with non-zero divisor
    public fun test_division_runner() {
        test_division(10, 2);
    }

    // A runner function to test modulo with non-zero divisor
    public fun test_modulo_runner() {
        test_modulo(10, 3);
    }
}
//# run 0xCAFE::ArithmeticTests::test_division_runner
//# run 0xCAFE::ArithmeticTests::test_modulo_runner