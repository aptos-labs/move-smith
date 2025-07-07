//# publish
module 0xabcde::conditional_multiply {
    fun check_and_multiply(x: u64, y: u64, condition: bool): u64 {
        let mut result = x;
        if (condition) {
            result = y;
        };
        // multiply by 5 regardless of condition
        let product = result * 5;
        invoke_action();
        // multiply by 4 if condition is true
        let adjusted_product = if (condition) { result * 4 } else { result * 2 };
        product + adjusted_product
    }

    fun invoke_action() {
        // Placeholder for side effect
        assert!(true, 1);
    }

    // A runner function to demonstrate internal flow
    fun run_check() {
        // No arguments needed
    }
}

//# run 0xabcde::conditional_multiply::check_and_multiply --args 15 3 true

//# run 0xabcde::conditional_multiply::check_and_multiply --args 15 3 false