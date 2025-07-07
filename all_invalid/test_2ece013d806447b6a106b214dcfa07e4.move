//# publish
module 0xABC::test_module {
    fun foo(): u64 {
        let _y = 5;
        // Store initial value of _y in x
        let x = _y;
        // Reassign _y to a new value
        _y = 10;
        x
    }

    // Run function to verify that foo() returns the initial value of _y (5)
    public fun test() {
        assert!(foo() == 5, 55);
    }

    // Inline functions accepting lambdas that multiply their results by different constants
    inline fun multiply(f: |u64, u64| u64, g: |u64, u64| u64, x: u64, y: u64): u64 {
        f(x, y) * g(x, y)
    }

    // Main function to test inline lambdas and their invocation
    public fun main(): u64 {
        multiply(
            |a: u64, b: u64| a * 2,
            |a: u64, b: u64| b * 3,
            4,
            5
        )
    }
}

//# run 0xABC::test_module::test
//# run 0xABC::test_module::main