//# publish
module 0xAB::ApplyFunctionTest {

    // This function applies a provided function 'f' to two u64 values and returns the result
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    // Test function that verifies 'apply' with an addition function
    public fun test_addition(): u64 {
        apply(|a, b| a + b, 10, 15)
    }

    // Test function that verifies 'apply' with a multiplication function
    public fun test_multiplication(): u64 {
        apply(|a, b| a * b, 4, 5)
    }

    // Runner function to invoke the tests
    public fun run_tests(): () {
        let sum = test_addition();
        let product = test_multiplication();
        // No assertions; just ensuring that the functions execute without errors
        // In a real test, you might return or log these values
        ()
    }
}

//# run 0xAB::ApplyFunctionTest::run_tests

//# publish
module 0xAB::RefFunctionInteraction {

    // This function takes a shared reference to a function trait with drop+copy and applies it
    public fun ref_apply(f: &|u64|u64 has drop+copy, x: u64): u64 {
        (*f)(x)
    }

    // This function takes a mutable reference to a function trait and modifies it to compose with itself
    public fun ref_mut_modify(f: &mut |u64|u64 has drop+copy, x: u64) {
        let original_f = *f;
        *f = |y| original_f(x + y);
    }

    // Test that passes a simple increment closure
    public fun test_ref_apply(): u64 {
        let f : |u64|u64 has drop+copy = |z| z + 3;
        ref_apply(&f, 7)
    }

    // Test that modifies a closure through a mutable reference
    public fun test_ref_mut(): u64 {
        let mut f : |u64|u64 has drop+copy = |z| z * 2;
        ref_mut_modify(&mut f, 5);
        f(2) // Should compute 5 + 2 = 7
    }

    // Runner function to execute tests
    public fun run(): () {
        let result1 = test_ref_apply();
        let result2 = test_ref_mut();
        // No assertions, just run to ensure correctness
        ()
    }
}

//# run 0xAB::RefFunctionInteraction::run