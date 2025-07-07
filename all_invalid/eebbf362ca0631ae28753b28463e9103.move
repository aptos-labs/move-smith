
//# publish
module 0xCAFE::TypeParamStructs {
    // Define struct with type parameters
    struct Wrapper<T> {
        value: T,
    }
    // Function to create a new instance with a concrete type
    public fun create_wrapper<T>(val: T): Wrapper<T> {
        Wrapper { value: val }
    }
    // Function to verify type parameter is functioning with vector of Wrappers
    public fun process_vectors<T>(vecs: vector<vector<Wrapper<T>>>) {
        let len = vector::length(&vecs);
        let i = 0;
        while (i < len) {
            let inner = vector::borrow(&vector::borrow(&vecs, i), 0);
            // Access value inside wrapper to force type usage
            let _ = &inner.value;
            i = i + 1;
        }
    }
}


//# publish
module 0xCAFE::ByteStringTests {
    // No struct needed, just functions for testing byte string literals
    public fun test_empty_bytes(): bool {
        // Empty byte string
        let bytes: vector<u8> = b"";
        // Check length is 0
        return vector::length(&bytes) == 0;
    }

    public fun test_ascii_bytes(): bool {
        let bytes: vector<u8> = b"Hello";
        // ASCII bytes for "Hello"
        return vector::length(&bytes) == 5
            && *vector::borrow(&bytes, 0) == 0x48 // 'H'
            && *vector::borrow(&bytes, 1) == 0x65 // 'e'
            && *vector::borrow(&bytes, 2) == 0x6C // 'l'
            && *vector::borrow(&bytes, 3) == 0x6C // 'l'
            && *vector::borrow(&bytes, 4) == 0x6F; // 'o'
    }

    public fun test_hex_escape_bytes(): bool {
        // Hex escape sequence in byte string
        let bytes: vector<u8> = x"DEADBEEF";
        // Should be 4 bytes: 0xDE, 0xAD, 0xBE, 0xEF
        return vector::length(&bytes) == 4
            && *vector::borrow(&bytes, 0) == 0xDE
            && *vector::borrow(&bytes, 1) == 0xAD
            && *vector::borrow(&bytes, 2) == 0xBE
            && *vector::borrow(&bytes, 3) == 0xEF;
    }
}


//# publish
module 0xCAFE::IteratorTests {
    use 0xCAFE::TypeParamStructs;

    // Function to run a for_each over an optional vector of vectors
    public fun run_for_each_option_vectors<T>(opt_vecs: option<vector<vector<Wrapper<T>>>>) {
        if (option::is_some(&opt_vecs)) {
            let vecs_ref = option::borrow(&opt_vecs);
            let len = vector::length(&vecs_ref);
            let i = 0;
            while (i < len) {
                let inner_vec = &vector::borrow(&vecs_ref, i);
                let inner_len = vector::length(inner_vec);
                let j = 0;
                while (j < inner_len) {
                    // Perform some action; for now, just borrow
                    let _ = &vector::borrow(inner_vec, j);
                    j = j + 1;
                }
                i = i + 1;
            }
        }
    }
}



//# run 0xCAFE::TypeParamStructs::create_wrapper --signers 0xCAFE --args "0xCAFE::ByteStringTests::test_empty_bytes()"

// Features:
// c4af56f7e8ef0854238512e39b8ef9b0: Define struct types with type parameters as type arguments
// 0282457de9fee7fde903c2fa3dbfff1a: Verify that byte string literals (e.g., b"") correctly represent their hexadecimal equivalents, including empty strings, ASCII characters, and hexadecimal escape sequences.
// 8098ba46b0fc6bb01717d129f465958f: Iterate over optional vectors of types with for_each to perform an action on each contained vector of types.