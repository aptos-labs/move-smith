
//# publish
module 0xCAFE::NativeLayoutModule {
    use std::vector;
    use std::error;
    // Removed unused 'string' import

    // Struct with native layout annotation
    struct NativeStruct has copy, drop, store, key {
        a: u64,
        b: bool,
    }

    // Function to test processing file format bytecode vector<u8>
    public fun process_bytecode(bytecode: vector<u8>): u64 {
        // Just return length to simulate usage for test purpose
        vector::length(&bytecode) as u64
    }

    // Function that attempts to parse a list element and return result or error string
    public fun parse_list_element(elem: u8): vector<u8> {
        // If unexpected token (say, value is 255), abort with error
        if (elem == 255u8) {
            // Abort with custom error code and message
            abort error::invalid_argument(101);
        };
        // Return single-element vector as successful parse result
        vector::singleton<u8>(elem)
    }

    // A dummy type structure for conversion
    struct Type {
        dummy_field: u8
    }

    struct ExpandedType {
        dummy_field: u8,
        expanded: bool
    }

    // Converts vector<Type> to vector<ExpandedType>
    public fun types(types_vec: vector<Type>): vector<ExpandedType> {
        let expanded_vec = vector::empty<ExpandedType>();
        let len = vector::length(&types_vec);
        let i = 0;
        while (i < len) {
            let t_ref = vector::borrow(&types_vec, i);
            let new_expanded = ExpandedType {
                dummy_field: t_ref.dummy_field,
                expanded: true,
            };
            vector::push_back(&mut expanded_vec, new_expanded);
            i = i + 1;
        };
        // Consume types_vec by unpacking to avoid implicit drop
        let vector::Vector { _dummy: _, data: _ } = types_vec;
        expanded_vec
    }

    // Public runner function without arguments for test execution
    public fun runner() {
        // Test 1: Process file format bytecode vector
        let bc = vector[0x49u8, 0x43u8, 0x45u8];
        let _len = Self::process_bytecode(bc);

        // Test 2: Parse valid element
        let _ = Self::parse_list_element(100u8);

        // Test 3: Types conversion
        let t1 = Type { dummy_field: 1u8 };
        let t2 = Type { dummy_field: 2u8 };
        let tvec = vector[t1, t2];
        let exvec = Self::types(tvec);
        // Consume exvec by unpacking the vector struct to avoid implicit drop error
        let vector::Vector { _dummy: _, data: _ } = exvec;
    }
}
