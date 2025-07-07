
//# publish
module 0xCAFE::ReferenceAndBytes {
    use std::signer;
    use std::vector;
    // Removed `use std::move;` as `move` is a keyword, not a module

    // A struct that holds a byte vector
    // Add `key` ability to allow storing under an address
    struct DataHolder has key, store {
        data: vector<u8>,
    }

    // Publish a DataHolder resource to the signer with specific bytestring data
    public fun publish_data(s: signer) {
        let data_bytes = b"Test\x01\x02Byte\nString";
        let data_holder = DataHolder { data: data_bytes };
        move_to<DataHolder>(s, data_holder);
    }

    // Returns an immutable reference to the data vector in the resource
    // Fix lifetime error by returning the whole reference to DataHolder,
    // not to a field of a local struct
    public fun borrow_data_ref(s: &signer): &vector<u8> {
        let addr = signer::address_of(s);
        // Borrow global resource
        // The returned reference is tied to the lifetime of the global resource,
        // so returning a reference to a field is safe by returning the entire reference
        let data_holder_ref: &DataHolder = borrow_global<DataHolder>(addr);
        &data_holder_ref.data
    }

    // Utilizes a literal address specifier with number values to get data length
    public fun data_length_from_literal_address(): u64 {
        // Wrap number in `@` to specify address literal (not using parentheses)
        let addr = @0xCAFE;
        let data_ref: &DataHolder = borrow_global<DataHolder>(addr);
        vector::length(&data_ref.data)
    }

    // Copy first byte of the byte string data passed as a reference
    public fun first_byte(data_ref: &vector<u8>): u8 {
        *vector::borrow(data_ref, 0)
    }
}




//# run 0xCAFE::ReferenceAndBytes::publish_data --signers 0xCAFE




//# run 0xCAFE::ReferenceAndBytes::borrow_data_ref --signers 0xCAFE




//# run 0xCAFE::ReferenceAndBytes::data_length_from_literal_address




//# run 0xCAFE::ReferenceAndBytes::first_byte --args b"T" 
