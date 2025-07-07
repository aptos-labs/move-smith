//# publish
module 0xAB::conditional_closure_tests {

    fun check_condition(c: bool, val_true: u64, val_false: u64): u64 {
        if (c) val_true else val_false
    }

    // Function that returns true if the external condition is met
    public fun run(): bool {
        let condition1 = |x: u64| if_then_else(condition_met, x, 0);
        let condition2 = |c: bool, x: u64| if_then_else(c, x, 100);
        let nested_condition = |x: u64, y: u64| if_then_else(c, x, y);

        // Call with closure that checks static condition
        assert!(condition1(50)  == 50);
        // Call with parameterized condition
        assert!(condition2(true, 75) == 75);
        assert!(condition2(false, 75) == 100);
        // Call with nested condition closure with different inputs
        assert!(nested_condition(20, 40) == if_then_else(c, 20, 40)); // c is true
        true
    }

    // Helper function to emulate conditional evaluation based on closure
    fun if_then_else(c: bool, t: u64, f: u64): u64 {
        if (c) t else f
    }

    // Internal boolean used in tests
    const c: bool = true; // or false to test different paths
}

//# run 0xAB::conditional_closure_tests::run

//# publish
module 0xAB::arith_closure_tests {

    fun add_mul(f1: |u64, u64| u64, f2: |u64, u64| u64, a: u64, b: u64, c: u64): u64 {
        let r1 = f1(a, b);
        let r2 = f2(b, c);
        r1 + r2 + a + c
    }

    public fun run(): bool {
        let closure_add = |x: u64, y: u64| x + y;
        let closure_mul = |x: u64, y: u64| x * y;

        // Using closures to perform arithmetic operations
        let result = add_mul(closure_add, closure_mul, 2, 3, 4);
        // Calculation: (2 + 3) + (3 * 4) + 2 + 4 = 5 + 12 + 6 = 23
        assert!(result == 23, result);
        true
    }
}

//# run 0xAB::arith_closure_tests::run