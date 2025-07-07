//# publish
module 0xabcde::local_reassign {
    fun compute(): u64 {
        let mut value = 5;    // initialize variable
        value = value + 10;    // reassign with updated value
        let multiplier = 2;
        value * multiplier     // combine reassigned variable with another
    }

    public fun run_test() {
        assert!(compute() == 30, 0); // 15 * 2 = 30
    }
}

//# run 0xabcde::local_reassign::run_test