
//# publish
module 0xCAFE::AttributeAndAcquisitionTest {
    use std::signer;

    // A resource to test proper acquires annotation
    struct R has key {}

    // Function that acquires the resource, must have acquires<R> annotation
    // test_attribute = "expected_fail"]
    public fun function_missing_acquire_annotation(s: signer) {
        let r = move_from<R>(signer::address_of(&s));
        let R {} = r; // consume r to avoid implicit drop error
    }

    // acquires(R)]
    public fun function_with_proper_acquire(s: signer) {
        let r = move_from<R>(signer::address_of(&s));
        let R {} = r; // consume r to avoid implicit drop error
    }

    // Function that tries to acquire a resource not defined in the acquires annotation, should fail
    // test_attribute = "expected_fail"]
    // acquires(R)]
    public fun function_acquire_wrong_resource(s: signer) {
        let addr = signer::address_of(&s);
        // Access R twice without second acquires annotation, simulating error
        let r1 = move_from<R>(addr);
        let R {} = r1; // consume r1

        let r2 = move_from<R>(addr);
        let R {} = r2; // consume r2
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
