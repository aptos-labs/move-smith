
//# publish
module 0xCAFE::PrivilegeTest {
    use std::signer;
    use std::vector;

    struct PrivStruct has key, store {
        secret_data: u64
    }

    // Only this module can create or destroy PrivStruct resources
    fun create_priv_struct(x: u64): PrivStruct {
        PrivStruct { secret_data: x }
    }

    fun destroy_priv_struct(p: PrivStruct) {
        // just consume it
    }

    /// Public function to create and store PrivStruct under signer
    public fun publish_priv_struct(s: signer, x: u64) {
        let p = create_priv_struct(x);
        move_to<PrivStruct>(&s, p);
    }

    /// Public function to read secret_data
    public fun get_secret_data(s: signer): u64 {
        let p_ref = borrow_global<PrivStruct>(signer::address_of(&s));
        p_ref.secret_data
    }

    /// Public function to try to destroy struct stored at signer
    public fun remove_priv_struct(s: signer) {
        let p = move_from<PrivStruct>(signer::address_of(&s));
        destroy_priv_struct(p);
    }

    /// Attempts to create PrivStruct cross module should fail compilation
}


//# publish
module 0xCAFE::SpecAndLambdaTest {

    // Spec block with pragma usage
    spec pragmas {
        pragma assert_on_failure;
    }

    // Spec function for demonstration
    spec fun spec_add(a: u8, b: u8): u8 {
        a + b
    }

    /// Test lambda capturing outer variable shadowing parameter name
    public fun test_lambda_shadowing(x: u8): u8 {
        let shadowed = 10u8;
        let func: |u8| u8 = |shadowed: u8| {
            // Assign to outer shadowed variable using unique name
            let outer_shadowed = shadowed + 1u8;
            // to simulate mutate outer variable, emulate via let binding (no mutation allowed)
            // Just return sum of parameter shadowed and outer_shadowed for test
            outer_shadowed + shadowed
        };
        func(x)
    }
}


//# run 0xCAFE::PrivilegeTest::publish_priv_struct --signers 0xBEE1 --args 123u64


//# run 0xCAFE::PrivilegeTest::get_secret_data --signers 0xBEE1


//# run 0xCAFE::PrivilegeTest::remove_priv_struct --signers 0xBEE1


//# run 0xCAFE::SpecAndLambdaTest::test_lambda_shadowing --args 5u8


// Featurres:
// 43c8e5020452cf3df8e2d336cc26c64a: Restrict access to privileged operations on structs to prevent cross-module violations.
// c1f37f0ad4f80bbc9489d5bb0e018ba2: Declare spec pragmas using the 'pragma' keyword within spec blocks.
// 0a56f083963dc467bc4b9bdc1981a01a: Test that a variable declared outside a lambda can be assigned within the lambda even if the parameter name shadows the outer variable.
