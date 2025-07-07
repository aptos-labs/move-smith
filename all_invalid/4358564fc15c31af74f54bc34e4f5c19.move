//# publish
module 0xCAFE::AvoidRestrictedNames {
    use std::vector;

    // This module avoids restricted Rust-style names and tests various identifier declarations
    // Also tests unpacking bindings and explicit return types

    struct MyStruct has copy, drop, store, key {
        x: u8,
        y: u64,
        z: vector<u8>,
    }

    // A tuple-like struct to test unpacking more simply
    struct TupleStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Function with explicit return type, returning u64
    public fun get_sum(): u64 {
        let s = MyStruct { x: 5u8, y: 10u64, z: b"abc" };
        let sum: u64 = (s.x as u64) + s.y;
        sum
    }

    // Function with destructuring assignment positionaly
    public fun destructure_struct(): u64 {
        let s = MyStruct { x: 3u8, y: 7u64, z: b"xyz" };
        let MyStruct { x, y, z } = s;
        // use unpacked variables, explicit return type
        let total: u64 = (x as u64) + y + (VectorLength(z) as u64);
        total
    }

    // Function with tuple-like struct unpacking positionaly
    public fun destructure_tuple_struct(): u64 {
        let t = TupleStruct { a: 2u8, b: 4u8 };
        let TupleStruct { a, b } = t;
        // Return sum
        (a as u64) + (b as u64)
    }

    // Test unpacking a tuple binding via let
    public fun destructure_tuple_binding(): u64 {
        let (x, y) = (10u64, 20u64);
        x + y
    }

    // Runner function without arguments for testing run command
    public fun runner(): u64 {
        let s = get_sum();
        let d = destructure_struct();
        let t = destructure_tuple_struct();
        let u = destructure_tuple_binding();
        s + d + t + u
    }

    // Helper: get vector length
    fun VectorLength(v: vector<u8>): u64 {
        let len = vector::length<u8>(&v);
        (len as u64)
    }
}
//# run 0xCAFE::AvoidRestrictedNames::runner --signers 0xCAFE