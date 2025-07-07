//# publish
module 0xA550C18::DeprecatedModule {
    #[deprecated]
    public fun deprecated_function(): u64 {
        42
    }

    #[deprecated]
    public struct DeprecatedStruct has copy, drop, store {
        pub field1: u64,
        pub field2: bool,
    }

    // Runner function to call deprecated_function, triggering warning on usage
    public fun runner(): u64 {
        deprecated_function()
    }
}
//# run 0xA550C18::DeprecatedModule::runner --signers 0xA550C18

//# publish
module 0xA550C18::FieldIterator {
    use std::vector;

    /// A struct with multiple fields
    struct MyStruct has copy, drop, store {
        field_a: u8,
        field_b: u64,
        field_c: bool,
    }

    /// Helper function to iterate over fields and handle each field individually
    /// Since Move does not have reflection, we simulate field iteration by returning
    /// the fields as a vector of strings describing them
    public fun get_fields(s: &MyStruct): vector<vector<u8>> {
        let fields = vector::empty<vector<u8>>();
        // Serialize field names and values to bytes vector<u8> for demonstration

        vector::push_back(&mut fields, b"field_a: ".to_vec());
        vector::push_back(&mut fields, vector::singleton(s.field_a));
        
        vector::push_back(&mut fields, b"field_b: ".to_vec());
        // field_b is u64, serialize to bytes little-endian, 8 bytes
        let b_bytes = to_bytes_u64(s.field_b);
        vector::push_back(&mut fields, b_bytes);

        vector::push_back(&mut fields, b"field_c: ".to_vec());
        if (s.field_c) {
            vector::push_back(&mut fields, b"true".to_vec());
        } else {
            vector::push_back(&mut fields, b"false".to_vec());
        };
        fields
    }

    /// Private helper returning the u64 as bytes little endian (8 bytes)
    fun to_bytes_u64(val: u64): vector<u8> {
        let mut result = vector::empty<u8>();
        let mut v = val;
        let mut i = 0;
        while (i < 8) {
            let byte = (v & 0xFF) as u8;
            vector::push_back(&mut result, byte);
            v = v >> 8;
            i = i + 1;
        }
        result
    }

    /// Runner to test field iteration
    public fun runner(): vector<vector<u8>> {
        let s = MyStruct {
            field_a: 7u8,
            field_b: 123456789u64,
            field_c: true,
        };
        get_fields(&s)
    }
}
//# run 0xA550C18::FieldIterator::runner

//# publish
module 0xA550C18::SpannedAddress {
    use std::signer;
    use std::vector;
    use std::string;

    /// A struct representing a spanned (location-aware) NumericalAddress
    struct SpannedAddress has copy, drop, store {
        address: address,
        filename: vector<u8>, // utf8 bytes
        line: u64,
        column: u64,
    }

    /// Create a SpannedAddress from components
    public fun make(address: address, filename: vector<u8>, line: u64, column: u64): SpannedAddress {
        SpannedAddress {
            address,
            filename,
            line,
            column,
        }
    }

    /// Accessors for SpannedAddress
    public fun get_address(sa: &SpannedAddress): address {
        sa.address
    }

    public fun get_filename(sa: &SpannedAddress): vector<u8> {
        sa.filename
    }

    public fun get_line(sa: &SpannedAddress): u64 {
        sa.line
    }

    public fun get_column(sa: &SpannedAddress): u64 {
        sa.column
    }

    /// Runner that returns the address part of a spanned address for further use
    public fun runner(): address {
        let filename = b"source.move".to_vec();
        let spanned = make(@0xA550C18, filename, 10, 5);
        get_address(&spanned)
    }
}
//# run 0xA550C18::SpannedAddress::runner