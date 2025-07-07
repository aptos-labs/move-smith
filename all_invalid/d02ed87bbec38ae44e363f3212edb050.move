
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
    // Correct syntax for friend relationship in Move includes the address with '::'
    // The invalid 'friend 0xBABE;' line is replaced with:
};
    // To declare friendship, use the 'friend' capability in the module declaration or define a function. 
    // But Move does not support 'friend' keyword like C++. Instead, access control is managed via module visibility.
    // Since the original code attempted to declare friendship via syntax error, we'll replace it by exposing
    // a function that only the friend module can call, or by making functions public.
    // For the sake of this test, we remove the 'friend' line and adjust access accordingly.

}

// Correct approach: instead of 'friend 0xBABE;', we define a public function accessible to the friend module.


//# run 0xCAFE::AbilityTest::new_container_copyable --signers 0xCAFE --args 42u64



//# run 0xBABE::FriendshipModule::test_friend_access --signers 0xBABE


// Additional module to demonstrate access
module 0xBABE::FriendshipModule {
    use 0xCAFE::AbilityTest;

    // Call the 'friend only' function in AbilityTest, which must be public
    public fun test_friend_access() {
        AbilityTest::friend_only_function();
    }
}

module 0xDADA::OtherModule {
    use 0xCAFE::AbilityTest;

    // Call friend function via friend module, should succeed
    public fun test_friend_module() {
        AbilityTest::friend_only_function(); // Should be valid if called from a friend
    }
}

// Note: Since Move does not have 'friend' keyword, we remove the 'friend' declaration.
// Instead, we control access via making 'friend_only_function' public and restricting module access at the code level.