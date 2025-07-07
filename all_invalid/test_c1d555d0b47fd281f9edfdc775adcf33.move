//# publish
module 0xABC::LoopTest {
    //# run
    fun test_break_in_if_else() {
        let counter = 0;
        let stop_signal = false;
        loop {
            if (stop_signal) {
                if (counter >= 5) {
                    continue;
                }
            } else {
                break;
            };
            // Simulate some work
            // Increment counter
            let new_counter = counter + 1;
            // Mutate counter for the next iteration
            // (In actual Move code, variables are immutable by default, but for test purposes we consider mutation)
            // Since variable mutation isn't directly supported, simulate with shadowing
            let counter = new_counter;
            // Optionally, change the stop_signal based on counter
            if (counter == 3) {
                // Set stop_signal to true to test nested break/continue
                // But since stop_signal is immutable, create new binding
                let stop_signal = true;
                // Recursion or loop break is not necessary for test; just check flow
            }
        }
    }
    //# run
    fun runner() {
        test_break_in_if_else();
    }
}

 //# publish
module 0xABC::FunctionInvocation {
    fun sum_functions(f1: |u64, u64| u64, f2: |u64, u64| u64, x: u64, y: u64): u64 {
        f1(x, y) + f2(x, y)
    }

    public fun test_inline_functions() {
        let result = sum_functions(
            |a, b| a + b,
            |a, b| a * b,
            4,
            5
        );
        // This should compute (4 + 5) + (4 * 5) = 9 + 20 = 29
        assert!(result == 29, 0);
    }
    //# run 0xABC::FunctionInvocation::test_inline_functions
}

 //# publish
module 0xDEF::Reassignment {
    fun test_variable_break_chain(p: u64): bool {
        let a = p;
        let mut b = a;
        let c = b;
        b = p + 10; // reassign b to break the copy chain
        a == c
    }

    public fun main() {
        assert!(test_variable_break_chain(42), 0);
    }
}
//# run 0xDEF::Reassignment::main