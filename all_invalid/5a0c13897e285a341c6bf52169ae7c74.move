// #publish
module 0xCAFE::MultiReturn {
    // Function returning multiple values
    public fun return_multiple_values(): (u64, bool, vector<u8>) {
        let num: u64 = 42;
        let flag: bool = true;
        let data: vector<u8> = b"hello";
        (num, flag, data)
    }

    // Runner function that calls the above function and does nothing with the return values
    public fun runner() {
        let (_num, _flag, _data) = Self::return_multiple_values();
    }
}
// #run 0xCAFE::MultiReturn::runner --signers 0xCAFE

// #publish
module 0xCAFE::ParseValueExample {
    use std::string;
    use std::vector;
    use std::option;
    use std::debug;

    /// A simplified Value enum to simulate parsing environment
    enum Value {
        U64(u64),
        Bool(bool),
        VectorU8(vector<u8>)
    }

    /// A very simplistic "token stream" type alias: just a vector<u8>
    /// The parse_value function parses a token (vector<u8>) into a Value enum
    public fun parse_value(token: vector<u8>): Value acquires {
        if (vector::length(&token) == 0) {
            debug::print(&string::utf8(b"parse_value: empty token"));
            abort 1;
        }
        // If token is just "true" or "false"
        if (token == b"true") {
            return Value::Bool(true);
        }
        if (token == b"false") {
            return Value::Bool(false);
        }
        // Try to parse as u64 number (decimal digits only)
        let mut num: u64 = 0;
        let len = vector::length(&token);
        let mut i = 0;
        while (i < len) {
            let c = *vector::borrow(&token, i);
            if (c < 48 || c > 57) {  // ASCII '0'=48 to '9'=57
                // Not a digit, treat as vector<u8> raw bytes
                return Value::VectorU8(token);
            }
            num = num * 10 + (u64::from(c) - 48);
            i = i + 1;
        }
        Value::U64(num)
    }

    public fun parse_value_runner() {
        let val1 = Self::parse_value(b"123");
        let val2 = Self::parse_value(b"false");
        let val3 = Self::parse_value(b"abc");

        // We just call parse_value to test the compiler and VM paths.
        // No asserts per instructions.
        let _ = val1;
        let _ = val2;
        let _ = val3;
    }
}
// #run 0xCAFE::ParseValueExample::parse_value_runner --signers 0xCAFE

// Featurres:
// b56d41b8b47cedba492633c363ede715: Return multiple values from functions
// 23482b3578da0ba999fc54c7f0f1b974: Use the parse_value function to parse a value from a token stream, expecting the token to represent a valid Value according to the language syntax.
// 9def49343c650663209a2268dd6c0e84: Define Move modules to encapsulate related code and resources.
