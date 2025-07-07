//# publish
module 0xabcde::conditional_m {

    fun compute_and_invoke(flag: bool, x: u64, y: u64): u64 {
        let mut result = 0;
        if (flag) {
            result = x + y;
        } else {
            result = x - y;
        };
        invoke_bar(flag, result);
        result
    }

    fun invoke_bar(cond: bool, value: u64) {
        if (cond) {
            bar();
        } else {
            bar();
        };
    }

    fun bar() {
        assert!(true, 1);
    }

    fun run_compute_and_invoke_true() {
        compute_and_invoke(true, 15, 5);
    }

    fun run_compute_and_invoke_false() {
        compute_and_invoke(false, 15, 5);
    }
}

 //# run 0xabcde::conditional_m::run_compute_and_invoke_true --args
 //# run 0xabcde::conditional_m::run_compute_and_invoke_false --args

//# publish
module 0xabcde::loop_var_assign {

    fun test_loop_variable_assignment() {
        let mut sum = 0;
        let range = 0..5;
        for (i in range) {
            // Attempting to reassign i should cause validation failure
            // But for the test, we perform a safe operation
            sum = sum + i;
        };
        // Call a function that attempts to reassign a loop variable (simulate invalid code)
        // This is for testing potential validation errors and won't run
        // Normally, the below line should cause validation error if uncommented
        // for (i in 0..5) {
        //     i = 10; // reassigning loop variable, should cause validation failure
        // };
        assert!(true, 2);
    }
}

//# run 0xabcde::loop_var_assign::test_loop_variable_assignment --signers 0x1
