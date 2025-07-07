
//# publish
module 0xCAFE::ReflectionTest {
    // Removed unused import: use std::string;
    use std::vector;

    const CONST_ONE: u64 = 1;
    const CONST_TWO: u64 = 2;

    struct DataStruct has copy, drop, store {
        value: u64,
    }

    struct AnotherStruct has key, store {
        data: u8,
    }

    public fun const_sum(): u64 {
        CONST_ONE + CONST_TWO
    }

    public fun member_kinds(): vector<u8> {
        // Encoding kinds as u8 for simplicity: 0 = function, 1 = struct, 2 = const
        let kinds = vector::empty<u8>();
        vector::push_back(&mut (kinds), 0u8); // function kind
        vector::push_back(&mut (kinds), 1u8); // struct kind
        vector::push_back(&mut (kinds), 2u8); // const kind
        kinds
    }

    public fun get_struct_handle_string(): vector<u8> {
        // Emulating a string like "0xCAFE::ReflectionTest::DataStruct"
        let addr_str = b"0xCAFE";
        let sep = b"::";
        let module_str = b"ReflectionTest";
        let struct_str = b"DataStruct";

        // Concat address :: module :: struct name
        let full_str = vector::empty<u8>();

        let add_bytes = &addr_str;
        let mod_bytes = &module_str;
        let struct_bytes = &struct_str;
        let sep_bytes = &sep;

        // Append addr_str
        let i = 0;
        while (i < vector::length(add_bytes)) {
            vector::push_back(&mut full_str, *vector::borrow(add_bytes, i));
            i = i + 1;
        };

        // Append ::
        let i = 0;
        while (i < vector::length(sep_bytes)) {
            vector::push_back(&mut full_str, *vector::borrow(sep_bytes, i));
            i = i + 1;
        };

        // Append module_str
        let i = 0;
        while (i < vector::length(mod_bytes)) {
            vector::push_back(&mut full_str, *vector::borrow(mod_bytes, i));
            i = i + 1;
        };

        // Append ::
        let i = 0;
        while (i < vector::length(sep_bytes)) {
            vector::push_back(&mut full_str, *vector::borrow(sep_bytes, i));
            i = i + 1;
        };

        // Append struct_str
        let i = 0;
        while (i < vector::length(struct_bytes)) {
            vector::push_back(&mut full_str, *vector::borrow(struct_bytes, i));
            i = i + 1;
        };

        full_str
    }

    /// Parse a list of u8 tokens representing numbers and commas with optional spaces.
    /// Return a vector of u8 containing only the number tokens (digits).
    /// Example input: ['1', ' ', ',', ' ', '2', ',', '3']
    /// Output: [1,2,3]
    public fun parse_number_list(tokens: vector<u8>): vector<u8> {
        let numbers = vector::empty<u8>();

        let length = vector::length(&tokens);
        let i = 0;
        while (i < length) {
            let c = *vector::borrow(&tokens, i);
            if (c >= 0x30u8 && c <= 0x39u8) {
                // ascii '0' to '9', convert ascii digit to number
                let digit = c - 0x30u8;
                vector::push_back(&mut (numbers), digit);
            };
            // else skip spaces (0x20) and commas (0x2c), or any other char
            i = i + 1;
        };
        numbers
    }

    public fun runner(): vector<u8> {
        let _ = const_sum();
        let _kinds = member_kinds();
        get_struct_handle_string()
    }
}

// The function parse_number_list takes a single argument: a vector<u8>, so `--args` must pass a single vector<u8> argument.
// We must wrap the argument list to pass the vector correctly.

// Instead of:
// 
//# run 0xCAFE::ReflectionTest::parse_number_list --args 49u8 32u8 44u8 32u8 50u8 44u8 51u8
// We must pass a single vector argument, e.g. --args [49u8, 32u8, 44u8, 32u8, 50u8, 44u8, 51u8]

// The Aptos CLI run command supports passing vectors inline as `[val1 val2 ...]`

// So the corrected run command line:


//# run 0xCAFE::ReflectionTest::parse_number_list --args '[49u8 32u8 44u8 32u8 50u8 44u8 51u8]'

//

// Or if the platform doesn't support quotes, remove quotes if possible or escape.

// Here is the fixed run command:


//# run 0xCAFE::ReflectionTest::parse_number_list --args [49u8 32u8 44u8 32u8 50u8 44u8 51u8]

// Also, no signers required, so no --signers


//# run 0xCAFE::ReflectionTest::runner


//# run 0xCAFE::ReflectionTest::const_sum


//# run 0xCAFE::ReflectionTest::member_kinds


//# run 0xCAFE::ReflectionTest::get_struct_handle_string


//# run 0xCAFE::ReflectionTest::parse_number_list --args [49u8 32u8 44u8 32u8 50u8 44u8 51u8]
