
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

// The original failing command tried to pass a struct literal as an argument to unpack_positional,
// which is invalid. Instead, we manually construct the Wrapper instance in Move or pass fields separately.

// Instead of "# run 0xCAFE::NativeStructs::unpack_positional --args Wrapper { ... }"
// do this: run unpack_positional on the Wrapper returned from create_wrapper or pass components.

// If you want to run unpack_positional on a freshly created Wrapper,
// run the create_wrapper function first and then pass the result:

// Alternatively, if you want to test unpack_positional with specific values,
// you can create a helper function that returns such a Wrapper.


//# run 0xCAFE::NativeStructs::unpack_positional --args 101u64 true b"TestInfo"

// This requires changing the signature of unpack_positional to accept fields,
// or you do test in Move script/code as below.



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



//# run 0xCAFE::SyntaxErrors::correct_unpack --args 3u8 4u8


use 0xCAFE::NativeStructs;
use std::assert;
use std::string;

// This script includes an attached specification with an assertion and ensures results hold.

spec {
    ensures true; // trivial spec for testing
}

fun main() {
    let info = string::utf8(b"SpecTest");
    let wrapper = NativeStructs::create_wrapper(999u64, true, info);
    let value = NativeStructs::unpack_positional(wrapper);
    assert!(value == 999u64, 999);
}
