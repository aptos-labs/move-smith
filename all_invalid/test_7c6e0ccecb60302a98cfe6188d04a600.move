//# publish
module 0xabcde::conditional_test {
    // Function that returns 5
    public fun five(): u64 {
        5
    }

    // Function that returns 15
    public fun fifteen(): u64 {
        15
    }

    // Public function to test local variable assignment
    public fun assign_and_return(): u64 {
        let value: u64;
        // Suppose some condition, for example, based on an argument or internal logic
        // but for simplicity, assign based on a static condition
        if (true) {
            value = five();
        } else {
            value = fifteen();
        }
        // Change the local variable
        value = fifteen();
        value
    }

    // Runner function for testing
    public fun run_test(): u64 {
        assign_and_return()
    }
}

//# run 0xabcde::conditional_test::run_test
