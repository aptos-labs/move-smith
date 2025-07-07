//# publish
module 0xCAFE::FriendModule {
    use std::signer;

    /// A private struct with uppercase letters
    struct DATA has key {
        value: u64,
    }

    /// A constant with uppercase letters
    const MAX_VALUE: u64 = 1000;

    /// Private data storage under friend module control
    resource struct FRIEND_DATA has key {
        secret: u64,
    }

    // Declare 0xCAFE::MainModule as friend to this module
    friend 0xCAFE::MainModule;

    /// Create private data
    fun create_data(): DATA {
        DATA { value: MAX_VALUE }
    }

    /// Create friend_data resource, only accessible by friends
    fun create_friend_data(): FRIEND_DATA {
        FRIEND_DATA { secret: 42 }
    }
}

//# publish
module 0xCAFE::MainModule {
    use std::signer;
    use 0xCAFE::FriendModule;

    // Declare 0xCAFE::FriendModule as friend to this module as well (for bidirectional friend access)
    friend 0xCAFE::FriendModule;

    /// Function with generic type parameter, no constraint, just a test
    public fun generic_function<T>(value: T): T {
        value
    }

    /// Runner function to test friend access and uppercase members
    public fun runner() {
        // Construct DATA from FriendModule - friend access allows this even if DATA struct is private in FriendModule
        let data = FriendModule::create_data();

        // Access constant - uppercase letters
        let _max = FriendModule::MAX_VALUE;

        // Create friend data resource
        let friend_data = FriendModule::create_friend_data();

        // Use generic function:
        let _x = generic_function<u64>(123);

        // Note: no asserts are required, just exercising access and calls
        // If you want to use the friend_data, just drop it here (no usage required)
        let _ = friend_data;
        let _ = data;
        let _ = _max;
        let _ = _x;
    }
}

//# run 0xCAFE::MainModule::runner --signers 0xCAFE

//# run 0xCAFE::MainModule::generic_function --args 42u64 --signers 0xCAFE

// Featurres:
// cdc26bbfba45f0272e755180a8d5a9a2: Declare friend modules in your module to allow privileged access to private members.
// 287f6aa7a642275ddfce9c9bbded8fec: Use uppercase letters to name structs, constants, or schemas.
// a0056ab4bdc4a5e262f9b3fda402ab12: Define functions with a name and optional type parameters.
