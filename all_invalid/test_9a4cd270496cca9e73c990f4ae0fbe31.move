//# publish
module 0xabcde::counter {
    // Module to test looping behavior with conditional break and assertions
    public fun increment_until_threshold() {
        let mut counter = 0;
        while (true) {
            if (counter >= 10) break;
            counter = counter + 2;
            continue;
        }
        // Store the final value for verification
        move_to(&signer, counter);
    }

    // Helper function to retrieve the stored counter value (assuming storage or simulation)
    public fun get_counter(): u64 acquires 0xabcde::counter {
        // For testing, simply return the value (simulate retrieval)
        // In an actual test environment, this might be replaced with assertions or storage access
        0 // placeholder, actual retrieval depends on test setup
    }
}

//# run 0xabcde::counter::increment_until_threshold

//# run 0xabcde::counter::get_counter --signers 0xabcde

//# publish
module 0xfedcb::test_functions {
    // Function that returns the input, used to verify correct parameter passing
    public fun return_input(val: u64): u64 {
        val
    }

    // Function that returns a constant value
    public fun constant_value(): u64 {
        42
    }

    // Function that calls return_input with a preset argument
    public fun test_runner(input_value: u64): u64 {
        return_input(input_value)
    }
}

//# run 0xfedcb::test_functions::return_input --args 99u64 --signers 0xfedcb

//# run 0xfedcb::test_functions::constant_value --signers 0xfedcb

//# run 0xfedcb::test_functions::test_runner --args 123u64 --signers 0xfedcb