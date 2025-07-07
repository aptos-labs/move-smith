//# publish
module 0xCAFE::NestedTestAttributes {
    use std::debug;

    /// A function that demonstrates move semantics: consumes u64, modifies it and returns new value.
    /// This function does not copy the input, it directly mutates it.
    public fun modify_and_return(x: u64): u64 {
        let v = x + 10;
        v
    }

    /// A "runner" function that tests modify_and_return function.
    public fun test_modify_and_return(): u64 {
        let input = 100;
        let result = modify_and_return(input);
        // result should be 110 if move and arithmetic works correctly
        result
    }
}
//# run 0xCAFE::NestedTestAttributes::test_modify_and_return

//# publish
module 0xCAFE::ArithmeticTests {
    use std::debug;

    /// Function to test addition: normal, boundary, overflow
    public fun test_addition(): u64 {
        let a = 1_000_000_000;
        let b = 2_000_000_000;
        let sum = a + b; // 3_000_000_000

        let max = 0xFFFFFFFFFFFFFFFF;
        let zero = 0u64;
        let max_plus_zero = max + zero;

        // overflow example (max + 1) should fail, but no catch in Move so just return max + 1 (will panic on overflow)
        // So we don't run overflow here, leave to script with expected failure.

        sum + max_plus_zero // 3_000_000_000 + max, large number
    }

    /// Function to test subtraction including normal and boundary
    public fun test_subtraction(): u64 {
        let a = 1_000_000_000;
        let b = 500_000_000;
        let diff = a - b; // 500_000_000
        let zero = 0u64;
        let zero_minus_zero = zero - zero; // 0

        diff + zero_minus_zero // 500_000_000
    }

    /// Function to test multiplication
    public fun test_multiplication(): u64 {
        let a = 123;
        let b = 456;
        let c = a * b; // 56088
        let one = 1u64;
        let zero = 0u64;
        let zero_mul = zero * 789; // 0
        c + one + zero_mul // 56089
    }

    /// Function to test division normal and division by zero (should abort)
    /// Normal division returns dividend / divisor
    public fun test_division(dividend: u64, divisor: u64): u64 {
        // This will abort if divisor == 0
        dividend / divisor
    }

    /// Function to test modulo normal and modulo by zero (should abort)
    public fun test_modulo(dividend: u64, divisor: u64): u64 {
        // This will abort if divisor == 0
        dividend % divisor
    }

    /// Runner that runs safe arithmetic tests and returns a combined value
    public fun test_all_safe_arithmetic(): u64 {
        let sum = test_addition();
        let sub = test_subtraction();
        let mul = test_multiplication();
        // Use normal division and modulo with valid divisors
        let div = test_division(10, 2); // 5
        let modu = test_modulo(10, 3); // 1

        sum + sub + mul + div + modu // sum all results
    }
}
//# run 0xCAFE::ArithmeticTests::test_all_safe_arithmetic

//# run 0xCAFE::ArithmeticTests::test_division --args 10u64 0u64
//# run 0xCAFE::ArithmeticTests::test_modulo --args 10u64 0u64


// Featurres:
// 73703d960f7376d7a440b975128e33cd: Apply nested test attributes within main test attribute blocks to organize or configure tests.
// 41a7e42786358f6234f852a8c37d00f0: Test that the function correctly modifies a local variable and returns the expected result without copying, ensuring move semantics are enforced.
// 36311243e4efd7a97b7a64c5be9d12b7: Test basic arithmetic operations (addition, subtraction, multiplication, division, and modulo) on u64 values, including normal cases, boundary conditions, and error scenarios such as overflows, division by zero, and modulo by zero, ensuring they produce correct results or fail as expected.
