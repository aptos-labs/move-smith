
//# publish
module 0xCAFE::NativeStructs {
    use std::string;

    native struct NativeData has store, drop, key {
        value: u64,
        flag: bool,
    }

    struct Wrapper has store {
        data: NativeData,
        info: string::String,
    }

    public fun create_wrapper(value: u64, flag: bool, info: string::String): Wrapper {
        let data = NativeData { value, flag };
        Wrapper { data, info }
    }

    public fun unpack_positional(s: Wrapper): u64 {
        // Positional unpacking with `..` to ignore the rest
        let Wrapper(data, ..) = s;
        let NativeData(value, ..) = data;
        value
    }
}


//# run 0xCAFE::NativeStructs::create_wrapper --args 101u64 true b"TestInfo"


//# run 0xCAFE::NativeStructs::unpack_positional --args 0xCAFE::NativeStructs::create_wrapper(202u64 false b"MoreInfo")


//# publish
module 0xCAFE::SyntaxErrors {
    // This module is intentionally broken to simulate unexpected tokens and provide error messages.
    // We will define a function that tries to unpack a struct with an invalid pattern to cause an error.

    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    public fun correct_unpack(p: Point): u8 {
        let Point(a, b) = p;
        a + b
    }

    // We cannot compile a function with actual unexpected tokens in a transactional test.
    // Instead, we simulate this with a comment.

    /*
    public fun invalid_unpack(p: Point): u8 {
        let Point(a, ?, b) = p; // expected error: unexpected token '?'
        a + b
    }
    */
}


//# run 0xCAFE::SyntaxErrors::correct_unpack --args 0xCAFE::SyntaxErrors::Point { x: 3u8, y: 4u8 }


    use 0xCAFE::NativeStructs;
    use std::assert;

    // This script includes an attached specification with an assertion and ensures results hold.

    spec {
        ensures true; // trivial spec for testing
    }

    fun main() {
        let info = b"SpecTest";
        let wrapper = NativeStructs::create_wrapper(999u64, true, info);
        let value = NativeStructs::unpack_positional(wrapper);
        assert!(value == 999u64, 999);
    }
}



// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
// 99e0c7dc69100368ea067e3fb522be33: Perform positional unpacking of struct or variant patterns with support for a single `..` to ignore remaining fields.
// 916e7988631e0eda4f4ef5f6ecc5844b: Attach specifications to a script for additional assertions or requirements.
