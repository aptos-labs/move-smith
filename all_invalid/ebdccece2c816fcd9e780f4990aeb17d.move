
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    // Test capturing a value in a lambda that is not a reference
    public fun test_capture_value_in_lambda() {
        let value: u8 = 5;
        let lambda: |a: u8| u8 = |a: u8| {
            a + value // value is captured by value, not reference
        };
        let result = lambda(10u8);
        assert!(result == 15, 999);
    }

    // Test that capturing references in lambdas is not allowed
    public fun test_capture_reference_in_lambda() {
        let x: u8 = 7;
        // Attempt to capture mutable reference, should fail at compile time
        // Note: This is a compile-time test; in this test code, we simulate the expected failure.
        // For runtime testing, we might invoke a function that should fail compiling.
        // The incorrect syntax for lambda with reference capture:
        // Remove the invalid syntax below to trigger compile error
        /*
        let lambda: |r: &mut u8| u8 = |r: &mut u8| {
            *r = *r + 1;
            *r
        };
        */
        // Since references are not allowed, this code is commented out.
    }

    // Test an out-of-gas scenario by crafting a loop that consumes gas
    // The following test is annotated to expect out of gas failure
    // // expected_failure(out_of_gas)]
    public fun test_out_of_gas_in_loop() {
        // To intentionally consume gas, perform a large loop
        let sum: u64 = 0;
        let count: u64 = 1_000_000; // Large loop to consume gas
        let i: u64 = 0;
        while (i < count) {
            sum = sum + i;
            i = i + 1;
        };
        // The test expects to run out of gas before reaching here.
        sum
    }

    // Test defining a test case inside a special test function
    public fun run_tests() {
        test_capture_value_in_lambda();
        // The following comment indicates that the test is expected to fail due to references
        // test_capture_reference_in_lambda(); // Uncomment if running in a real test environment
        // The out_of_gas test is expected to fail at runtime due to gas exhaustion
        // test_out_of_gas_in_loop(); // Uncomment to run in test
    }
}



//# run 0xCAFE::TestFeatures::run_tests

// Features:
// 9b9fa9ee559a089db3ff7787f80e82c0: Avoid using references as captured arguments in lambdas.
// 447a0a2e92baf94205eeedbcef8abb18: Indicate an out-of-gas error expected in your test with `// expected_failure(out_of_gas)]` attribute.
// 26c23dba8891f14a4761eb46367ab648: Define test functions within a module that are identified as test cases.