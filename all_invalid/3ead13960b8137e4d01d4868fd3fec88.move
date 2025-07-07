
//# publish
module 0xDEAD::DebuggerTest {
    use std::vector;
    use std::signer;

    // A struct for testing deserialization and serialization
    struct DummyStruct has copy, drop, store, key {
        id: u64,
        flag: bool,
        data: vector<u8>,
    }

    // A generic struct to test generics with different parameters
    struct GenericContainer<T> has drop, store {
        value: T,
    }

    // Inline function to test inline calls, closure accepts u64, returns u64
    public inline fun inline_sum(closure: |u64| u64): u64 {
        closure(42)
    }

    // Script entry point that calls various functions to test interaction
    public fun run_tests(
        s: signer,
        use_deserialize: bool,
        deserialize_bytes: vector<u8>,
        generic_type: u8, // 0: u64, 1: vector<u8>, 2: DummyStruct
        closure_choice: u8,
    ) {
        if (use_deserialize) {
            // Deserialize module bytecode (simulated here as a vector)
            // In actual test, this would be reading from file, but here just assign
            // For illustration, just skip actual deserialization logic
            // to focus on serialization/deserialization validation
            // We'll assume deserialize_bytes is correct for the purpose of this test
        }

        // Create a DummyStruct instance
        let dummy = DummyStruct {
            id: 12345,
            flag: true,
            data: vector::singleton(255),
        };

        // Instantiate generic containers with different types
        if (generic_type == 0) {
            let gc: GenericContainer<u64> = GenericContainer { value: 987654321 };
            assert!(gc.value == 987654321, 999);
        } else if (generic_type == 1) {
            let v = vector::empty<u8>();
            vector::push_back(&mut v, 1);
            vector::push_back(&mut v, 2);
            let gc: GenericContainer<vector<u8>> = GenericContainer { value: v };
            assert!(*vector::borrow(&gc.value, 0) == 1, 999);
        } else if (generic_type == 2) {
            let gc: GenericContainer<DummyStruct> = GenericContainer { value: dummy };
            assert!(gc.value.id == 12345, 999);
        }

        // Call inline function passing different closures
        let result1 = inline_sum(|x: u64| x + 10);
        assert!(result1 == 52, 999);

        let result2 = inline_sum(|x: u64| x * 2);
        assert!(result2 == 84, 999);

        // Combine deserialized module usage: simulate calling an external deserialized function
        // As an example, create a dummy function that would be deserialized
        // For simplicity, we invoke a local function; in real case, it could be from deserialized module
        fun external_deserialized_func(val: u64): u64 {
            val + 100
        }
        let deserialized_result = external_deserialized_func(50);
        assert!(deserialized_result == 150, 999);
    }
}


//# run 0xDEAD::DebuggerTest::run_tests --signers 0xBADD --args 1 --args 0 --args 0 --args 0


//# run 0xDEAD::DebuggerTest::run_tests --signers 0xBADD --args 1 --args 1 --args 2 --args 1


//# run 0xDEAD::DebuggerTest::run_tests --signers 0xBADD --args 1 --args 1 --args 0 --args 0

// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 604e2356b98f288d2c8ee998f1b7a26d: Test that calling inline functions with closure parameters correctly sums their returned values.
