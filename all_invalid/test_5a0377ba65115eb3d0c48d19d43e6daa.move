//# publish
module 0xabc::nested_if_test {
    fun nested_condition(p: bool): bool {
        if (p) {
            if (p) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public fun run_nested_if() {
        // Call the function with true (should return true)
        let result1 = nested_condition(true);
        // Call the function with false (should return false)
        let result2 = nested_condition(false);
        assert!(result1, 0);
        assert!(!result2, 1);
    }
}

//# run 0xabc::nested_if_test::run_nested_if

//# publish
module 0xabc::parameter_assign {
    fun assign_and_return(p: u64): u64 {
        let mut _x = one();
        // Assign parameter p to local variable _x
        _x = p;
        _x
    }

    fun one(): u64 {
        1
    }

    public fun run_assign() {
        let test_value = 99;
        let result = assign_and_return(test_value);
        // Result should be equal to test_value
        assert!(result == test_value, 0);
    }
}

//# run 0xabc::parameter_assign::run_assign

//# publish
module 0xabc::enum_field_access {
    // Enum with multiple variants
    enum Response has drop {
        Success { code: u64, message: u8 },
        Error { code: u64, source: bool },
        Pending { reason: u8 }
    }

    fun test_response_success(): u64 {
        let res = Response::Success { code: 200, message: 1 };
        res.code
    }

    fun test_response_error(): u64 {
        let res = Response::Error { code: 404, source: true };
        res.code
    }

    fun test_response_pending(): u64 {
        let res = Response::Pending { reason: 3 };
        res.reason as u64
    }
}

//# run 0xabc::enum_field_access::test_response_success

//# run 0xabc::enum_field_access::test_response_error

//# run 0xabc::enum_field_access::test_response_pending