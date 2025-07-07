//# publish
module 0x10::enum_test {
    enum Status has drop {
        Success,
        Failure(u8),
    }

    // Function to return the first variant's index
    fun get_status_variant(status: Status): u8 {
        match status {
            Success => 0,
            Failure(_) => 1,
        }
    }

    // Runner function to test get_status_variant with Success
    public fun test_success(): u8 {
        let s = Status::Success;
        get_status_variant(s)
    }

    // Runner function to test get_status_variant with Failure
    public fun test_failure(): u8 {
        let s = Status::Failure(255);
        get_status_variant(s)
    }

    // High-level test to verify correct variant identification
    fun run_tests() {
        assert!(test_success() == 0, 100);
        assert!(test_failure() == 1, 101);
    }
}

//# run --verbose -- 0x10::enum_test::run_tests