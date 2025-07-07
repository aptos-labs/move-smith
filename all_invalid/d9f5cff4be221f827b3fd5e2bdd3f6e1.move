
//# publish
module 0xCAFE::AccessControlTest {
    use std::signer;

    // Define a resource with restricted access
    struct SecretResource has key {
        secret_value: u64,
    }

    // Public function to publish secret resource, only callable by signer
    public fun publish_secret(s: &signer): () {
        move_to<SecretResource>(s, SecretResource { secret_value: 42 });
    }

    // Function to access secret, with access check
    public fun access_secret(s: &signer): u64 acquires SecretResource {
        // borrowing global resource
        let secret_ref: &SecretResource = borrow_global<SecretResource>(signer::address_of(s));
        secret_ref.secret_value
    }

    // Inline function with access check
    public fun get_secret_inline(s: &signer): u64 {
        access_secret(s)
    }

    // Function to remove secret resource
    public fun remove_secret(s: &signer) {
        move_from<SecretResource>(signer::address_of(s));
    }
}



//# run 0xCAFE::AccessControlTest::publish_secret --signers 0xBEEF


//# run 0xCAFE::AccessControlTest::access_secret --signers 0xBEEF


//# run 0xCAFE::AccessControlTest::get_secret_inline --signers 0xBEEF


//# run 0xCAFE::AccessControlTest::remove_secret --signers 0xBEEF

// Test illegal access, expected to abort (accessing after removal)


//# run 0xCAFE::AccessControlTest::access_secret --signers 0xBEEF -- --expected_failure

// Explicit side effect: after resource is removed, accessing again should fail


//# run 0xCAFE::AccessControlTest::access_secret --signers 0xBEEF -- --expected_failure

// Additional test: try calling remove again, should fail


//# run 0xCAFE::AccessControlTest::remove_secret --signers 0xBEEF -- --expected_failure

// Inline access after removal should also fail


//# run 0xCAFE::AccessControlTest::get_secret_inline --signers 0xBEEF -- --expected_failure




//# publish
module 0xCAFE::InlineAccessCheck {
    use std::signer;

    struct Data has key {
        value: u8,
    }

    public fun initialize(s: &signer): () {
        move_to<Data>(s, Data { value: 10 });
    }

    // Access function with inline check
    public fun check_data(s: &signer): u8 {
        let data_ref: &Data = borrow_global<Data>(signer::address_of(s));
        data_ref.value
    }
}



//# run 0xCAFE::InlineAccessCheck::initialize --signers 0xDEED


//# run 0xCAFE::InlineAccessCheck::check_data --signers 0xDEED

// Simulate inlining scenario: call check_data after resource is removed to trigger failure


//# publish
module 0xCAFE::FailOnAccess {
    use std::signer;

    struct Dummy has key {
        flag: bool,
    }

    public fun setup(s: &signer): () {
        move_to<Dummy>(s, Dummy { flag: true });
    }

    // expected_failure]
    public fun access_after_removal(s: &signer): bool acquires Dummy {
        borrow_global<Dummy>(signer::address_of(s)).flag
    }
}



//# run 0xCAFE::FailOnAccess::setup --signers 0xFACE


//# run 0xCAFE::FailOnAccess::access_after_removal --signers 0xFACE -- --expected_failure

// Featurres:
// a187f459e56c8e4de4858233b8ac4bda: Restrict access and usage of functions and resources with access checks both before and after inlining
// b6bf5ea92384cae62bdb1b60ae305195: Annotate Move functions or tests with // expected_failure] or // expected_failure(KIND)] attributes to specify expected runtime failures.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.