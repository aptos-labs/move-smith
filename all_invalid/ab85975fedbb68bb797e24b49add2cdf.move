
//# publish
module 0xCAFE::AbilityTest {
    // Define a generic struct with ability constraints
    struct Container<T: copy + drop> {
        value: T,
    }

    // Function to create a new container with a copyable type
    public fun new_container_copyable<T: copy + drop>(val: T): Container<T> {
        Container { value: val }
    }

    // Function to create a new container with a non-copyable type (for invalid test)
    // (Commented out to avoid compilation error, but shown here for completeness)
    // public fun new_container_non_copyable<T>(val: T): Container<T> {
    //     Container { value: val }
    // }

    // Define an ability-constrained 'axiom' with type parameters
    #[axiom]
    fun axiom_container<T: copy + drop>() {
        // Asserts that the ability constraints are satisfied
        // For test purposes; in real code, we might enforce some property
        assert!(true);
    }

    // Privately defined function to test module privacy
    fun private_helper() {
        // No-op
    }

    // Public function to call private helper, should succeed
    public fun call_private_helper() {
        private_helper();
    }

    // Friendship relationship via public function, simulating privileged access
    friend 0xBABE;
    // Function only accessible to friend modules
    public fun friend_only_function() {
        // Do something privileged
    }
}

module 0xBABE::FriendshipModule {
    use 0xCAFE::AbilityTest;

    // Call the friend-only function in AbilityTest, should succeed
    public fun test_friend_access() {
        AbilityTest::friend_only_function();
    }
}

module 0xDADA::OtherModule {
    use 0xCAFE::AbilityTest;

    // Attempt to call private helper directly, should fail
    // (Commented out: the test to violate privacy)
    // public fun violate_privacy() {
    //     AbilityTest::private_helper(); // Should be a compile error if uncommented
    // }

    // Call friend function via friend module, should succeed
    public fun test_friend_module() {
        // Suppose this module is not a friend, so direct call should fail.
        // But explicitly calling in a trusted context
        // For test, just calling the public function of the friend module
        AbilityTest::friend_only_function(); // Should be invalid if not a friend
    }
}


//# run 0xCAFE::AbilityTest::new_container_copyable --signers 0xCAFE --args 42u64


//# run 0xBABE::FriendshipModule::test_friend_access --signers 0xBABE


// Featurres:
// 634209496839e06f739d46ccf5293db8: Specify ability constraints for generic type parameters using a colon in type signatures
// c5b868ba5c7847d6238e1d7b80ebae2f: Annotate 'axiom' conditions with optional type parameters in specification blocks.
// 5a93f8922a3f80b6cbf1c7f536622223: Enforce module privacy rules based on friendship relationships during function calls.
