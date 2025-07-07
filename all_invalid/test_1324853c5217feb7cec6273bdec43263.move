//# publish
module 0x1::persistent_resource_test {
    use 0x1::signer;

    // Define a persistent resource with a u64 value, stored per signer
    struct PersistentCounter has store, key, drop {
        count: u64,
    }

    #[persistent]
    fun new_counter(): u64 {
        0
    }

    // Entry function to store a new persistent resource
    entry fun initialize(s: &signer) {
        move_to(s, PersistentCounter { count: new_counter() })
    }

    // Entry function to increment the counter
    entry fun increment(s: &signer) acquires PersistentCounter {
        let addr = signer::address_of(s);
        let mut counter = move_from::<PersistentCounter>(addr);
        counter.count = counter.count + 1;
        move_to(s, counter);
    }

    // Entry function to read the counter value
    fun get_counter(addr: &signer): u64 acquires PersistentCounter {
        let counter = move_from::<PersistentCounter>(signer::address_of(addr));
        let value = counter.count;
        // Return the counter without modifying
        move_to(addr, counter);
        value
    }
}

//# run 0x1::persistent_resource_test::initialize --signers 0x1
//# run 0x1::persistent_resource_test::increment --signers 0x1
//# run 0x1::persistent_resource_test::get_counter --signers 0x1

//# publish
module 0x3::custom_resource_verification {
    use 0x1::signer;

    // Define a simple custom resource with a string value
    struct MessageResource has store, key, drop {
        message: vector<u8>,
    }

    // Function to store a message for an account
    fun store_message(s: &signer, msg: vector<u8>) {
        move_to(s, MessageResource { message: msg })
    }

    // Function to retrieve the message resource, checking contents
    fun retrieve_message(addr: address): vector<u8> acquires MessageResource {
        // move_from consumes resource; move_to will re-store
        let msg_resource = move_from::<MessageResource>(addr);
        let msg = copy(&msg_resource.message);
        move_to(&signer::borrow_address(&signer::reference_of(addr)), msg_resource);
        msg
    }

    // Helper function to compare two messages
    fun compare_messages(msg1: &vector<u8>, msg2: &vector<u8>): bool {
        vector::equals(msg1, msg2)
    }
}

//# run 0x3::custom_resource_verification::store_message --signers 0x3 --args "b\"Hello, Move!\""
//# run 0x3::custom_resource_verification::retrieve_message --signers 0x3
//# run 0x3::custom_resource_verification::compare_messages --args "vector[b\"Hello, Move!\"] vector[b\"Hello, Move!\"]"
