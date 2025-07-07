
//# publish
module 0xCAFE::AttributeAndAcquisitionTest {
    use std::signer;

    // A resource to test proper acquires annotation
    struct R has key {}

    // Function that acquires the resource, must have acquires<R> annotation
    // test_attribute = "expected_fail"]
    public fun function_missing_acquire_annotation(s: signer) {
        let _r = move_from<R>(signer::address_of(&s));
    }

    // acquires<R>]
    public fun function_with_proper_acquire(s: signer) {
        let _r = move_from<R>(signer::address_of(&s));
    }

    // Function that tries to acquire a resource not defined in the acquires annotation, should fail
    // test_attribute = "expected_fail"]
    // acquires<R>]
    public fun function_acquire_wrong_resource(s: signer) {
        let addr = signer::address_of(&s);
        // Dummy type to cause error, as type definition does not exist
        // This line is to simulate an error from improper acquires annotation access
        // Here we simulate by accessing R twice without a second acquires annotation
        let _r1 = move_from<R>(addr);
        let _r2 = move_from<R>(addr);
    }

    // Function that tests attribute with on/off experiment flags
    // named_experiment = "my_exp=on"]
    public fun experiment_on() {}

    // named_experiment = "another_exp=off"]
    public fun experiment_off() {}

    // named_experiment = "just_exp"]
    public fun experiment_default() {}

    // Runner function that calls experiment functions
    public fun run_experiment_tests() {
        Self::experiment_on();
        Self::experiment_off();
        Self::experiment_default();
    }
}


//# run 0xCAFE::AttributeAndAcquisitionTest::function_missing_acquire_annotation --signers 0xBEEF


//# run 0xCAFE::AttributeAndAcquisitionTest::function_with_proper_acquire --signers 0xBEEF


//# run 0xCAFE::AttributeAndAcquisitionTest::function_acquire_wrong_resource --signers 0xBEEF


//# run 0xCAFE::AttributeAndAcquisitionTest::run_experiment_tests


// Featurres:
// 5d8ca82e690a4416078b1ec313376cde: Use attributes with assign syntax to specify attributes with assigned values that signal expected failures.
// 7cb9e69f486261eb0a12a25ab96bab61: Check for proper acquisition annotations in code.
// 5261fe6d66f5c0fb96e593b96dea3caa: Turn on or off named experiments in the compiler by passing `<exp_name>` for on or `<exp_name>=on/off` for explicit control.
