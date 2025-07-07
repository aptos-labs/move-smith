//# publish
module 0xabcde::mutability_test {
    fun assign_and_mutate(): u64 {
        let value = 10;
        let mut mutable_value = value;
        mutable_value = mutable_value + 15;
        // Return the mutated value
        mutable_value
    }

    public fun main() {
        let result = assign_and_mutate();
        // Expect the mutated value to be 25
        assert!(result == 25, 6);
    }
}

//# run 0xabcde::mutability_test::main

//# publish
module 0xfedcb::loop_test {
    fun run_infinite_loop() {
        loop {
            // Infinite loop to test gas consumption
        }
    }

    public fun trigger_loop() {
        run_infinite_loop();
    }
}

//# run 0xfedcb::loop_test::trigger_loop --signers 0x1 --gas-budget 700