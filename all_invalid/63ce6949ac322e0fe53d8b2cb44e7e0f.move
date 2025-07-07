
//# publish
module 0xCAFE::FunctionFeatures {
    use std::signer; // warning: unused alias; can be removed if not used

    // Declare a native function (simulated here as an external function)
    native public fun external_compute(x: u64): u64;

    // Function that uses unused local variables for computations
    public fun compute_with_unused(x: u64): u64 {
        let a = x + 1;
        let _unused_var1 = a * 2; // unused variable
        let _unused_var2 = a - 1; // another unused variable
        a * 3 // return value
    }

    // Function that demonstrates calling an external (native) function
    public fun call_external(x: u64): u64 {
        external_compute(x)
    }

    // Function that demonstrates updating variable value
    public fun update_value(initial: u64): u64 {
        let value = initial; // 'value' needs to be mutable
        value = value + 10;
        // update the value before returning
        value
    }

    // Runner function to test the above functions
    public fun run_tests() {
        // Test compute_with_unused with a sample input
        let result1 = compute_with_unused(7);
        // The expected return is 7 * 3 = 21
        assert!(result1 == 21, 999);

        // Test call_external (simulate native call)
        let result2 = call_external(15);
        // For test purposes, assume external_compute returns input * 2
        // which would be 30
        assert!(result2 == 30, 998);

        // Test update_value
        let result3 = update_value(5);
        // Expect 5 + 10 = 15
        assert!(result3 == 15, 997);
    }
}


//# run 0xCAFE::FunctionFeatures::run_tests