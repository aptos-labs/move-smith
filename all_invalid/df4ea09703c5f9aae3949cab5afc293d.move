//# publish
module 0xCAFE::LoopAssign {
    /// Test 1:
    /// Assign a parameter to a local variable inside a loop, confirm final value reflects last assignment.
    public fun run_loop_assign_param(n: u64): u64 {
        let mut x = 0;
        let mut i = 0;
        while (i < n) {
            // assign parameter n each iteration
            x = n;
            i = i + 1;
        };
        x
    }

    /// Test 2:
    /// Sequences of statements inside a block
    public fun run_sequence(): u64 {
        let mut a = 1;
        {
            let b = 2;
            a = a + b;
            let c = 3;
            a = a + c;
        };
        a // expect 1 + 2 +3 = 6
    }

    /// Test 3:
    /// Parse a comma-separated list of types enclosed in parentheses into a vector of (field, type) pairs
    /// with sequentially named fields "0", "1", ...
    /// Return vector of vector<u8> encoding the field name (as a string) and type name.
    ///
    /// We simulate the type parsing by passing a string with comma separated types and parse into vector.
    /// Since Move doesn't have reflection or string parsing directly, simulate by passing vector<string> representing types.
    /// This "parsing" function accepts `types: vector<vector<u8>>` where each is a type name.
    /// It will return vector<(field_name, type_name)> pairs.
    ///
    /// This is a simplified test to cover the logic of sequential field naming + pairing.
    public fun parse_types(types: vector<vector<u8>>): vector<(vector<u8>, vector<u8>)> {
        let mut res: vector<(vector<u8>, vector<u8>)> = vector::empty();
        let mut i = 0;
        while (i < vector::length(&types)) {
            let field_name = to_string_u8(vector::length(&res)); // converts current length to u8 digit(s)
            let ty = *vector::borrow(&types, i);
            vector::push_back(&mut res, (field_name, ty));
            i = i + 1;
        };
        res
    }

    /// Helper: convert numeric index to string in u8, simplified for single digit (0..9)
    fun to_string_u8(n: u64): vector<u8> {
        let mut s = vector::empty<u8>();
        assert!(n <= 9, 0); // only single digit
        vector::push_back(&mut s, (n as u8) + 48); // ASCII '0' = 48
        s
    }
}

//# run 0xCAFE::LoopAssign::run_loop_assign_param --args 10u64
//# run 0xCAFE::LoopAssign::run_sequence
//# publish
module 0xCAFE::TypesParser {
    use std::vector;
    use std::string;

    /// This module supplements parse_types to a more complex scenario:
    /// Parse a string of format "(Type1, Type2, Type3)" into vector<(field, type)>
    /// Since Move has no native string split, this is emulated by passing a vector of type names (vector<vector<u8>>)
    /// So this module just re-exposes parse_types with a little wrapping.
    public fun parse_types_wrapper(types: vector<vector<u8>>): vector<(vector<u8>, vector<u8>)> {
        // Simply call parse_types of LoopAssign module (simulate import)
        LoopAssign::parse_types(types)
    }
}

//# run 
script {
    use std::vector;
    use std::string;

    /// Construct the test of parsing a comma-separated list of types into vector<(field,type)>
    /// emulating input: (u8, bool, u64)
    fun main() {
        let mut types = vector::empty<vector<u8>>();
        vector::push_back(&mut types, string::utf8(b"u8"));
        vector::push_back(&mut types, string::utf8(b"bool"));
        vector::push_back(&mut types, string::utf8(b"u64"));

        let res = 0xCAFE::TypesParser::parse_types_wrapper(types);

        // `res` is a vector<(vector<u8>, vector<u8>)> with fields "0", "1", "2" and types "u8", "bool", "u64"
        // No assertions needed per instructions
        ()
    }
}
//# run

// Featurres:
// 2a6995db2f3ff1669cc090ddf8f5ea9c: Test that assigning a parameter to a local variable inside a loop updates the variable correctly and that the final value reflects the last assignment.
// 334af8b93b6806c10fbc9f479f2cef89: Write sequences of statements inside functions or blocks
// 5c12958def199320ccdb7345cfcaca38: Parse comma-separated list of types enclosed in parentheses into a vector of (field, type) pairs with sequentially named fields '0', '1', ... in move code.
