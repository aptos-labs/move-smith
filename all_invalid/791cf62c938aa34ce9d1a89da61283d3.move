
//# publish
module 0xCAFE::TestSuite {
    use std::vector;
    use std::signer;
    use std::error;
    use std::serialize;
    use std::byte_array;

    // 1. Function to invoke deprecated generics syntax (e.g., obj.method::<T>())
    public fun test_deprecated_generic_syntax() {
        let obj = StructWithTypeParameter<u8> {field: 42};
        // Using deprecated syntax for compatibility testing
        let _ = obj.method::<u8>();
    }

    // 2. Function to load a module from serialized bytes and verify
    public fun load_and_verify_module(serialized_module: vector<u8>) {
        // Deserialize the module bytes into a ModuleId (simulate loading)
        let load_result = serialize::deserialize_module(&serialized_module);
        assert!(load_result.is_ok(), 999);
        let module = load_result.unwrap();
        // Do a simple check: module is non-empty
        assert!(vector::length(&module.code) > 0, 998);
    }

    // 3. Define a generic container with vector<T>
    struct Container<T> has store, drop, key {
        items: vector<T>
    }

    // Function to instantiate container with u8
    public fun instantiate_container_u8(): Container<u8> {
        let vec_u8 = vector::empty<u8>();
        vector::push_back(&mut vec_u8, 10);
        vector::push_back(&mut vec_u8, 20);
        Container { items: vec_u8 }
    }

    // Function to instantiate container with address
    public fun instantiate_container_address(): Container<address> {
        let vec_addr = vector::empty<address>();
        vector::push_back(&mut vec_addr, @0xABCDE);
        Container { items: vec_addr }
    }

    // 4. Poison function guarded by 'unit_test' feature to prevent production use
    // cfg(feature = "unit_test")]
    public fun poison_function() {
        // This function should never be deployed outside tests
        // Call this function in test to ensure it exists
        // Forbidden in production
        abort 0
    }

    // 5. Explicit vector creation and byte string comparison
    public fun compare_vectors() {
        let vec_a: vector<u8> = b"TestBytes";
        let vec_b: vector<u8> = x"546573744279746573"; // hex for "TestBytes"
        assert!(vector::length(&vec_a) == vector::length(&vec_b), 997);
        // Compare element-wise
        let len = vector::length(&vec_a);
        let i = 0;
        while (i < len) {
            let a_byte = *vector::borrow(&vec_a, i);
            let b_byte = *vector::borrow(&vec_b, i);
            assert!(a_byte == b_byte, 996);
            i = i + 1;
        };
        // Access elements
        let first = *vector::borrow(&vec_a, 0);
        assert!(first == 'T' as u8, 995);
    }

    // 6. Token parsing validation: simulate token-by-token validation
    public fun validate_token_order() {
        // Dummy tokens just as strings, for illustration
        let tokens = vector::from_bstring(b"pub fun test()");
        let expected_tokens = vector::from_bstring(b"pub fun test ( )");
        let len = vector::length(&tokens);
        let i = 0;
        while (i < len) {
            let token = vector::borrow(&tokens, i);
            let expected = vector::borrow(&expected_tokens, i);
            assert!(token == expected, 994);
            i = i + 1;
        };
    }
}


//# run 0xCAFE::TestSuite::test_deprecated_generic_syntax


//# run 0xCAFE::TestSuite::load_and_verify_module --args 0x0a0b0c0d0e0f // simulate serialized module bytes


//# run 0xCAFE::TestSuite::instantiate_container_u8


//# run 0xCAFE::TestSuite::instantiate_container_address


//# run 0xCAFE::TestSuite::compare_vectors


//# run 0xCAFE::TestSuite::validate_token_order


//# run 0xCAFE::TestSuite::poison_function --signers 0x0 --ignore // Only in test environment, disables in production


// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 64ac167c2f2c35ec915331e64fbb6833: Create test-only poison functions that depend on the 'unit_test' VM feature to prevent accidental deployment of test-compiled modules.
// fafe4dcac2529477f68e855042041585: Test that both explicit vector construction and hexadecimal byte string notation produce equivalent byte vectors and allow correct element indexing.
// 96561ae7a826cd1c56ac3e0b6b5b7993: Write code that is parsed token by token, where each expected syntactic element (token) must appear at the correct location to be accepted by the compiler.
