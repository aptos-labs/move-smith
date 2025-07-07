
//# publish
module 0xDEAD::NativeFeatures {
    // Demonstrate native modifier usage
    native fun native_add(x: u64, y: u64): u64;

    // Define a constant as module member
    const MAX_U64: u64 = 18446744073709551615;

    // Inline function with specification
    public inline fun inline_multiply(a: u64, b: u64): u64 {
        a * b
    }

    // Function that uses the native and inline functions
    public fun test_native_and_inline(x: u64, y: u64): u64 {
        let sum = native_add(x, y);
        let product = inline_multiply(sum, 2)
    }

    // Function that returns the constant
    public fun get_max_u64(): u64 {
        MAX_U64
    }
}


//# run 0xDEAD::NativeFeatures::test_native_and_inline --args 3 4


//# run 0xDEAD::NativeFeatures::get_max_u64


// Featurres:
// a7ebfa887699363af1eb7542d0845eb4: Mark module members as native using the 'native' modifier.
// cef92f7a645ac4c90856fea8bcbe1cdb: Define constants as members of a module
// 437c337878908cd2a0d8e57fa14c0f0c: Write Move functions with inline specifications to enable specification checking.
