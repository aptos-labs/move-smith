
//# publish
module 0xCAFE::TestFeatures {
    // Removed unused import `std::signer`

    // A function that computes the addition of two u8 values and returns a fixed value after
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        // Mark _sum as unused so no warning, since sum is unused
        let _sum = a + b;
        let fixed_value = 42u8;
        fixed_value
    }

    // Function with lambdas performing arithmetic and returning tuples
    public fun lambda_arithmetic(): (u8, u8) {
        let add_mul: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        add_mul(3u8, 5u8)
    }

    // Function containing if-else, while and loop control flows
    public fun control_flows(start: u8): u8 {
        let val = start;

        if (val < 5) {
            val = val + 10;
        } else {
            val = val + 20;
        };

        while (val < 30) {
            val = val + 1;
        };

        loop {
            if (val == 35) {
                break;
            };
            val = val + 1;
        };

        val
    }

    // For loop with invariant: sum must be less than limit (fixed to avoid abort)
    public fun for_loop_invariant_violation(limit: u8) {
        let sum = 0u8;
        // Changed range to 0..=4u8 instead of 0..10u8 to prevent abort
        for (i in 0..5u8) {
            sum = sum + i;
            // invariant: sum must be less than limit, abort with code 99 if violated
            assert!(sum < limit, 99);
        };
    }

    public fun run_all() {
        let _ = add_and_return_fixed(4u8, 8u8);
        let (_s, _p) = lambda_arithmetic();
        let _c = control_flows(3u8);
        // We run for_loop_invariant_violation with limit=20 which will not abort now
        for_loop_invariant_violation(20u8);
    }
}




//# run 0xCAFE::TestFeatures::add_and_return_fixed --args 10u8 20u8




//# run 0xCAFE::TestFeatures::lambda_arithmetic




//# run 0xCAFE::TestFeatures::control_flows --args 2u8




//# run 0xCAFE::TestFeatures::for_loop_invariant_violation --args 20u8




//# run 0xCAFE::TestFeatures::run_all
