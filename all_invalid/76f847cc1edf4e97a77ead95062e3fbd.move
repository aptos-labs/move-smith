
//# publish
module 0xCAFE::NamespaceTest {
    use std::vector;
    use std::signer;

    // Spec block attached to module for documentation and verification
    spec module {
        // We document a constant here for spec purposes
        const SpecConstant: u64 = 100;
    }

    const VALUE: u8 = 42;

    // A struct to test keys and specs
    struct Data has store, key {
        value: u8,
    }

    // Native function declared here just specification; implementation in VM
    native public fun native_increment(x: u8): u8;

    // Declared native function requires no body

    // Function with code body
    public fun increment_and_store(s: signer, x: u8) {
        let result = native_increment(x);
        let data = Data {value: result};
        move_to<Data>(&s, data);
    }

    // Function to read stored data
    public fun get_value(s: signer): u8 {
        let addr = signer::address_of(&s);
        let data_ref = borrow_global<Data>(addr);
        data_ref.value
    }

    // Attach spec block to a function that has body
    spec increment_and_store {
        ensures exists<Data>(signer::address_of(&s));
    }

    public fun runner() {
        // Just a runner that calls native_increment and does nothing else
        let _ = native_increment(10u8);
    }
}



//# run 0xCAFE::NamespaceTest::increment_and_store --signers 0xBEEF --args 5u8



//# run 0xCAFE::NamespaceTest::get_value --signers 0xBEEF



//# run 0xCAFE::NamespaceTest::runner



//# publish
module 0xDEAD::SpecNative {
    use std::signer;

    // Spec block attached to the native function declaration
    native public fun native_multiply(a: u8, b: u8): u8;
    spec native_multiply {
        // Specification: the result equals multiplication of inputs
        ensures result == a * b;
    }

    public fun use_native_multiply(a: u8, b: u8): u8 {
        native_multiply(a, b)
    }
}



//# run 0xDEAD::SpecNative::use_native_multiply --args 7u8 8u8



//# publish
module 0xBEEF::BodyTest {
    use std::signer;

    struct Counter has store, key {
        count: u64,
    }

    // Function with body defined by statements (not native)
    public fun initialize_counter(s: signer) {
        let count = 0u64;
        let counter = Counter {count};
        move_to<Counter>(&s, counter);
    }

    // Function with native body
    native public fun native_increment_counter(s: signer);

    // Non-native function calling native
    public fun increment(s: signer) {
        native_increment_counter(s);
    }

    // Function to get count
    public fun get_count(s: signer): u64 {
        let addr = signer::address_of(&s);
        let counter_ref = borrow_global<Counter>(addr);
        counter_ref.count
    }

    // Runner function for testing
    public fun run() {
        // Intentionally empty
    }
}



//# run 0xBEEF::BodyTest::initialize_counter --signers 0xFEED



//# run 0xBEEF::BodyTest::increment --signers 0xFEED



//# run 0xBEEF::BodyTest::get_count --signers 0xFEED
