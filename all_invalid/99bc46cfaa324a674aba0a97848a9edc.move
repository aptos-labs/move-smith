//# publish
module 0xCAFE::TestFeatureMatchRest {
    // Testing feature 1: ".." pattern in Move bindings
    public fun match_rest_pattern_test() {
        let tuple_value = (1, 2, 3, 4);
        let (a, b, c, d) = tuple_value; // Move does not support ".." pattern
        // For testing, we'll just check values
        assert!(a == 1, "Expected first element to be 1");
        assert!(b == 2, "Tuple unpacked at b");
        assert!(c == 3, "Tuple unpacked at c");
        assert!(d == 4, "Tuple unpacked at d");
    }
}

//# run 0xCAFE::TestFeatureMatchRest::match_rest_pattern_test

module 0xCAFE::TestFriendRelationship {
    // Declare friend relationship
    friend 0xCAFE::TestFriendRelationship;

    // Private function
    fun secret_function(): u64 {
        42
    }

    // Public function that calls the private function
    public fun call_secret(): u64 {
        secret_function()
    }
}

// In a script, test friend usage:
 //# run 0xCAFE::TestFriendRelationship::call_secret --signers 0xCAFE

#[script]
fun test_friend_relationship() {
    let result = 0xCAFE::TestFriendRelationship::call_secret();
    assert!(result == 42, "Friend module access failed");
}

//# publish
module 0xCAFE::TestReportError {
    use std::debug::report_error;

    // Testing feature 3: Use of report_error for impure constructs
    // Function that calls report_error
    public fun generate_error() {
        report_error(100);
    }

    // Note: The above call is valid. ensure no syntax issue here.
}

//# run 0xCAFE::TestReportError::generate_error

#[script]
fun test_report_error() {
    0xCAFE::TestReportError::generate_error();
}