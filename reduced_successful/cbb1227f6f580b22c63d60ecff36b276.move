
//# publish
module 0xCAFE::BytecodeNative {
    use std::vector;
    use std::signer;

    // Native layout struct with store and key abilities
    // This simulates a resource that might be compiled from stackless bytecode file format
    struct NativeResource has store, key {
        id: u64,
        data: vector<u8>,
    }

    // Publish a resource with given id and data bytes
    public fun publish_resource(s: signer, id: u64, data: vector<u8>) {
        let resource = NativeResource { id, data };
        move_to<NativeResource>(&s, resource);
    }

    // View stored resource data length
    public fun data_length(s: signer): u64 {
        let addr = signer::address_of(&s);
        let r = borrow_global<NativeResource>(addr);
        vector::length(&r.data) as u64
    }

    // Update a byte at a specific index with bounds check
    public fun update_byte(s: signer, idx: u64, byte: u8) {
        let addr = signer::address_of(&s);
        let r_mut = borrow_global_mut<NativeResource>(addr);

        // Check index in bounds
        let len = vector::length(&r_mut.data) as u64;
        assert!(idx < len, 4001);

        // Since Move vector index is usize, convert idx to u64 then to u8 by cast (u64 -> u8 not allowed).
        // Instead convert u64 idx to u64 then to usize via std::convert::u64_to_usize
        // But std::convert module does not exist in Aptos Move, so use 'idx as u64' and then 'idx as u64' is useless.
        // The canonical way is use 'idx as u64' is wrong, but 'idx as u8' is also wrong.
        // We need to convert idx (u64) to usize, but Move does not have usize type.
        // Aptos has vector::borrow_mut(&mut vector, idx as u64)?
        // The vector::borrow_mut expects index as u64 or u8 or u16?  
        // Actually the vector::borrow_mut expects an index of `u64` type starting in the newer versions but in Aptos the function signature is:
        // `fun borrow_mut<T>(v: &mut vector<T>, index: u64): &mut T;`
        // So we can use idx directly.
        // So replace `let i = idx as usize; *vector::borrow_mut(&mut r_mut.data, i) = byte;` with `*vector::borrow_mut(&mut r_mut.data, idx) = byte;`

        *vector::borrow_mut(&mut r_mut.data, idx) = byte;
    }

    public fun destructive_pop(s: signer): u8 {
        let addr = signer::address_of(&s);
        let r_mut = borrow_global_mut<NativeResource>(addr);

        let popped = vector::pop_back(&mut r_mut.data);
        popped
    }

    public fun example_native_layout(): NativeResource {
        let data = vector[0xDEu8, 0xAD, 0xBE, 0xEF];
        NativeResource { id: 42u64, data }
    }
}




//# run 0xCAFE::BytecodeNative::publish_resource --signers 0xBADD --args 1u64 b"444154415f4259544553"




//# run 0xCAFE::BytecodeNative::data_length --signers 0xBADD




//# run 0xCAFE::BytecodeNative::update_byte --signers 0xBADD --args 0u64 0x99u8




//# run 0xCAFE::BytecodeNative::data_length --signers 0xBADD




//# run 0xCAFE::BytecodeNative::destructive_pop --signers 0xBADD




//# publish
module 0xCAFE::ListErrorHandling {
    use std::vector;

    // Attempting to parse a list of u8 bytes and simulate unexpected token check
    // Returns length of valid prefix before error detected
    public fun parse_u8_list(bytes: vector<u8>): u64 {
        let i = 0;
        while (i < vector::length(&bytes)) {
            let b = *vector::borrow(&bytes, i);
            // Consider 0xFF as an unexpected token in parsing list
            if (b == 0xFF) {
                // Abort with error code on unexpected token
                assert!(false, 9999);
            };
            i = i + 1;
        };
        i as u64
    }

    // Wrapper which returns 0 on abort via catching logic in test harness (simulated)
    public fun safe_parse(bytes: vector<u8>): u64 {
        parse_u8_list(bytes)
    }

    // Construct valid list of bytes with no unexpected token (0xFF)
    public fun valid_bytes_list(): vector<u8> {
        vector[1u8, 2u8, 3u8, 0xA1u8]
    }

    // Construct invalid list containing unexpected token 0xFF
    public fun invalid_bytes_list(): vector<u8> {
        vector[5u8, 10u8, 0xFFu8, 20u8]
    }
}




//# run 0xCAFE::ListErrorHandling::parse_u8_list --args b"01020304"




//# run 0xCAFE::ListErrorHandling::parse_u8_list --args b"01FF02"




//# run 0xCAFE::ListErrorHandling::valid_bytes_list




//# run 0xCAFE::ListErrorHandling::invalid_bytes_list




//# run 0xCAFE::ListErrorHandling::safe_parse --args b"010203"




//# run 0xCAFE::ListErrorHandling::safe_parse --args b"01FF03"
