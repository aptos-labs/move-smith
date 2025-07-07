//# publish
module 0x1234::test_module {
    // Top-level spec block as a resource or a struct (simulating a spec)
    struct Spec {
        value: u64,
        description: vector<u8>,
    }

    // Inline non-native function with body
    public fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Additional inline function for subtraction
    public fun inline_sub(a: u64, b: u64): u64 {
        a - b
    }

    // Inline multiplication
    public fun inline_mul(a: u64, b: u64): u64 {
        a * b
    }

    // Inline division with zero check
    public fun inline_div(a: u64, b: u64): u64 {
        // In Move, division by zero panics
        assert!(b != 0, 42);
        a / b
    }

    // Inline modulo with zero check
    public fun inline_mod(a: u64, b: u64): u64 {
        // In Move, modulo by zero panics
        assert!(b != 0, 42);
        a % b
    }

    // Function to test addition, including overflow detection
    public fun test_add_overflow() {
        let max = u64::MAX;
        // This should panic due to overflow
        // Uncomment to test overflow panic
        // inline_add(max, 1);
    }

    // Function to test subtraction underflow
    public fun test_sub_underflow() {
        // Subtracting larger from smaller without checks will panic
        // Uncomment to test underflow panic
        // inline_sub(0, 1);
    }

    // Function to test multiplication overflow
    public fun test_mul_overflow() {
        let max = u64::MAX;
        // Multiplying max by 2 should overflow
        // Uncomment to test overflow panic
        // inline_mul(max, 2);
    }

    // Function to test division by zero
    public fun test_div_by_zero() {
        // Uncomment to test division by zero panic
        // inline_div(10, 0);
    }

    // Function to test modulo by zero
    public fun test_mod_by_zero() {
        // Uncomment to test modulo by zero panic
        // inline_mod(10, 0);
    }

    // Runner function to execute some tests
    public fun run_tests() {
        // Basic operations
        let sum = inline_add(10, 20);
        let diff = inline_sub(50, 20);
        let prod = inline_mul(5, 4);
        let quotient = inline_div(100, 5);
        let rem = inline_mod(10, 3);

        // Boundary cases
        let max = u64::MAX;
        // overflow addition (commented out: uncomment to test panic)
        // inline_add(max, 1);
        // underflow subtraction (commented out)
        // inline_sub(0, 1);
        // multiplication overflow (commented out)
        // inline_mul(max, 2);
        // division by zero (commented out)
        // inline_div(10, 0);
        // modulo by zero (commented out)
        // inline_mod(10, 0);
    }
}

//# run 0x1234::test_module::run_tests