
//# publish
module 0xCAFE::ReferenceAndBytes {
    use std::signer;
    use std::vector;

    // A struct that holds a byte vector
    struct DataHolder has store {
        data: vector<u8>,
    }

    // Publish a DataHolder resource to the signer with specific bytestring data
    public fun publish_data(s: signer) {
        let data_bytes = b"Test\x01\x02Byte\nString";
        let data_holder = DataHolder { data: data_bytes };
        move_to<DataHolder>(&s, data_holder);
    }

    // Returns an immutable reference to the data vector in the resource
    public fun borrow_data_ref(s: &signer): &vector<u8> {
        let addr = signer::address_of(s);
        let data_ref: &DataHolder = borrow_global<DataHolder>(addr);
        &data_ref.data
    }

    // Utilizes a literal address specifier with number values to get data length
    public fun data_length_from_literal_address(): u64 {
        let addr = (0xCAFE);
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


// Featurres:
// 01226eadfc8d9de219465983d3917789: Use byte string literals that decode to byte arrays in Move code.
// 2c710bad4e3169dae09e82112c3f1b70: Declare a literal address specifier with a byte sequence using a number value, e.g., '(0x1234)'.
// b209c36a585632f90e3d0971998eb855: Use reference types to borrow data immutably without taking ownership.
