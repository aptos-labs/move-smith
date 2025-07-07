
//# publish
module 0xCAFE::CastAndUnusedGenericTest {
    use std::vector;
    use std::signer;

    // Struct with a generic parameter that is not used (to check for unused generic parameter warnings)
    struct UnusedGeneric<T> has copy, drop {
        x: u8,
    }

    struct UsedGeneric<T> has copy, drop {
        x: T,
    }

    // Struct with an array field to test indexing
    struct ArrayHolder has copy, drop {
        arr: vector<u8>,
    }

    // Return a u64 casted from a u8 input
    public fun cast_u8_to_u64(x: u8): u64 {
        (x as u64)
    }

    // Return a u8 casted from a u64 input, truncated
    public fun cast_u64_to_u8(x: u64): u8 {
        (x as u8)
    }

    // Create and return UnusedGeneric<u64> instance (T unused in the struct)
    public fun create_unused_generic(): UnusedGeneric<u64> {
        UnusedGeneric { x: 42u8 }
    }

    // Create and return UsedGeneric<u64> instance (T used)
    public fun create_used_generic(): UsedGeneric<u64> {
        UsedGeneric { x: 9000u64 }
    }

    // Create an ArrayHolder and return the value at index 2
    public fun index_vector(): u8 {
        let v = vector[10u8, 20u8, 30u8, 40u8];
        let arr_holder = ArrayHolder { arr: v };
        // index into vector using square brackets
        arr_holder.arr[2]
    }

    // Modify the vector at index 1 to 99u8 and return it
    public fun modify_index_vector(): u8 {
        let v = vector[1u8, 2u8, 3u8];
        v[1] = 99u8;
        v[1]
    }

    public fun runner() {
        let _ = cast_u8_to_u64(5u8);
        let _ = cast_u64_to_u8(300u64);
        let _ = create_unused_generic();
        let _ = create_used_generic();
        let _ = index_vector();
        let _ = modify_index_vector();
    }
}


//# run 0xCAFE::CastAndUnusedGenericTest::cast_u8_to_u64 --args 7u8


//# run 0xCAFE::CastAndUnusedGenericTest::cast_u64_to_u8 --args 300u64


//# run 0xCAFE::CastAndUnusedGenericTest::create_unused_generic


//# run 0xCAFE::CastAndUnusedGenericTest::create_used_generic


//# run 0xCAFE::CastAndUnusedGenericTest::index_vector


//# run 0xCAFE::CastAndUnusedGenericTest::modify_index_vector


//# run 0xCAFE::CastAndUnusedGenericTest::runner


// Featurres:
// 731afee126a5b5dec85cc47af1e6afba: Cast expressions to a different type with the `as` operator.
// 507e9c51f3a2c8fe28eabbaff8cedec4: Detect and warn about unused struct generic parameters
// d7251deb557b3a3afcdca0d1bf9f3502: Index into arrays or vectors using square brackets, such as `vec[i]`.
