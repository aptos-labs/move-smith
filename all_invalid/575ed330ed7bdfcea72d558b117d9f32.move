
//# publish
module 0xCAFE::VariableScopeTest {
    use std::assert;

    // Internal function to perform some computations
    fun internal_compute_sum(a: u64, b: u64): u64 {
        let sum = a + b;
        sum
    }

    // Internal function to test variable shadowing
    fun shadowing_test(x: u64): u64 {
        let x = x * 2; // shadow outer x
        let y = x + 10;
        y
    }

    // Internal restricted visibility function, should not be accessible externally
    fun restricted_helper(): u8 {
        42
    }

    // Public wrapper to test internal call
    public fun call_internal_compute(a: u64, b: u64): u64 {
        internal_compute_sum(a, b)
    }

    // Public function with loops and variable manipulations
    public fun loop_variable_test(limit: u64): u64 {
        let total = 0;
        let i = 0;
        while (i < limit) {
            let temp = i * 2; // local variable inside loop
            total = total + temp;
            i = i + 1;
        };
        total
    }

    // Public function to test shadowing
    public fun test_shadowing(val: u64): u64 {
        let result = shadowing_test(val);
        result
    }

    // Attempt to call restricted helper from outside, should be invalid.
    // This is to test access restriction, but since this is a test script, we just document.
}


//# run 0xCAFE::VariableScopeTest::call_internal_compute --args 10 20


//# run 0xCAFE::VariableScopeTest::loop_variable_test --args 5


//# run 0xCAFE::VariableScopeTest::test_shadowing --args 7


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
