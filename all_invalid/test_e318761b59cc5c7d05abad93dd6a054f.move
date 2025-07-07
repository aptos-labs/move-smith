//# publish
module 0x55::enum_test {
    // Define an enum with multiple variants, each holding different types
    enum Status has drop {
        Active(u64),
        Inactive,
        Error(string),
    }

    // Function to access the first field of the `Status` enum variants
    fun get_variant_value(s: Status): u64 {
        match s {
            Status::Active(val) => val,
            Status::Inactive => 0,
            Status::Error(msg) => 0, // For variant without a numeric value
        }
    }

    // Function that constructs different enum variants and tests the accessor
    fun test_enum_access(): u64 {
        let active_status = Status::Active(123456);
        let inactive_status = Status::Inactive;
        let error_status = Status::Error("fail".to_string());

        // Access first field of each variant
        let active_value = get_variant_value(active_status);
        let inactive_value = get_variant_value(inactive_status);
        let error_value = get_variant_value(error_status);

        // Return the active variant's value as a test indicator
        active_value + inactive_value + error_value
    }

    // Optional: runner function to invoke the test without args
    public fun run_test() {
        test_enum_access();
    }
}

//# run --verbose -- 0x55::enum_test::run_test