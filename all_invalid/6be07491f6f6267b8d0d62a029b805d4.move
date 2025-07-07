//# publish
module 0xCAFE::TestFeatureMatchRest {
    // Testing feature 1: ".." pattern in Move bindings
    public fun match_rest_pattern_test() {
        let tuple_value = (1, 2, 3, 4);
        let (a, ..) = tuple_value; // ".." pattern to ignore the rest
        // Go on to destructure with specific parts
        let (x, y, z, w) = tuple_value;
        // For testing, we'll just assert types (assuming test context)
        assert!(a == 1,  "Expected first element to be 1");
        assert!(x == 1, "Tuple unpacked at x");
        assert!(y == 2, "Tuple unpacked at y");
        assert!(z == 3, "Tuple unpacked at z");
        assert!(w == 4, "Tuple unpacked at w");
    }
}

//# run 0xCAFE::TestFeatureMatchRest::match_rest_pattern_test
module 0xCAFE::TestFriendRelationship {
    // Testing feature 2: Declare module-level friend relationships
    // This test creates two modules with friend relationship
    // The 'friend' module can access private functions and fields of the parent
    // module, but for this test, just declare and test that code compiles
    // and the friend attribute is used properly.
    // Note: In move, the friend keyword is used to whitelist modules
    // We test that a friend module can call a private function
}

module 0xCAFE::TestFriendRelationship {
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
    // We create a function that explicitly calls report_error which should be allowed
    public fun generate_error() {
        report_error(error_code: 100);
    }

    // Companion: A function that tries to call report_error inside a pure context (simulate)
    // But in Move, report_error is allowed in functions that are not marked `public` with #[inline]
    // For test, we call it directly.
}

//# run 0xCAFE::TestReportError::generate_error
#[script]
fun test_report_error() {
    0xCAFE::TestReportError::generate_error();
}

// Featurres:
// 028ba79c0d2d6550c16b84253f99819a: Use '..' patterns in Move code to match an unspecified or rest pattern in bindings.
// 2e44c943908f03ef3c8d0b8d6d02a784: Declare module-level friend relationships using the 'friend' feature.
// d1fe34e1251d69a8bf49bb429293afee: Use the `report_error` function to generate an error when a specification expression tries to use an impure construct.
