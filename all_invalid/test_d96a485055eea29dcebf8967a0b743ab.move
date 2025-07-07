//# publish
module 0xabcde::calc {
    fun compute_sum(): u64 {
        let a = 10;
        let b = 20;
        let c = 30;
        a + b + c
    }

    public fun runner() {
        // This function can be called to perform the test without arguments
        // No assertions needed here; just a demonstration
        compute_sum();
    }
}

//# run 0xabcde::calc::runner

//# publish
module 0xabcde::interaction {
    use 0xabcde::calc;

    public fun main() {
        let total = calc::compute_sum();
        // Check if the sum is exactly 60
        assert!(total == 60, 1);
    }
}

//# run 0xabcde::interaction::main