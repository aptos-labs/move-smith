//# publish
module 0xABCDEF::TestModule {
    fun sum_decreasing(n: u64): u64 {
        let total = 0;
        let mut r = n;
        let mut accumulator = 0;

        while ({let x = r; r = r - 1; accumulator = accumulator + x; r > 0}) {
            // Loop to sum decreasing from n to 1
        }
        total = n + accumulator; // Sum of initial n plus sum of decreasing sequence
        total
    }

    fun call_sum(n: u64): u64 {
        sum_decreasing(n)
    }

    public fun run_test(n: u64): u64 {
        call_sum(n)
    }
}

//# run 0xABCDEF::TestModule::run_test --args 15