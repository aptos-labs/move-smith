// The test address is 0xCAFE

//# publish
module 0xCAFE::LargeVectorEquality {
    use std::vector;

    // Define a constant large vector with 900 elements all set to 42u8
    const LARGE_VECTOR: vector<u8> = vector::empty<u8>();

    const LARGE_VECTOR_INIT: vector<u8> = {
        let mut v = vector::empty<u8>();
        let mut i = 0u64;
        while (i < 900) {
            v = vector::push_back<u8>(v, 42u8);
            i = i + 1;
        };
        v
    };

    // A const boolean that checks equality of two large vectors of 900 elements
    // both initialized with 42u8 so they should be equal.
    const EQUAL_VECTORS: bool = vector::equals<u8>(LARGE_VECTOR_INIT, LARGE_VECTOR_INIT);

    // A const boolean that checks inequality by comparing LARGE_VECTOR_INIT with a vector of 900 elements but 43u8
    const LARGE_VECTOR_DIFF: vector<u8> = {
        let mut v = vector::empty<u8>();
        let mut i = 0u64;
        while (i < 900) {
            v = vector::push_back<u8>(v, 43u8);
            i = i + 1;
        };
        v
    };

    const UNEQUAL_VECTORS: bool = !vector::equals<u8>(LARGE_VECTOR_INIT, LARGE_VECTOR_DIFF);

    struct MyStruct has copy, drop, store, key {
        val: u64,
    }

    // Equality function for MyStruct
    public fun equal_structs(lhs: &MyStruct, rhs: &MyStruct): bool {
        lhs.val == rhs.val
    }

    // Function to test equality of u64 and struct values
    public fun test_equality(): bool {
        let a = 999u64;
        let b = 999u64;
        let c = 1000u64;
        let res1 = a == b; // true
        let res2 = a == c; // false

        let s1 = MyStruct { val: 42u64 };
        let s2 = MyStruct { val: 42u64 };
        let s3 = MyStruct { val: 43u64 };
        let res3 = equal_structs(&s1, &s2);
        let res4 = equal_structs(&s1, &s3);

        res1 && !res2 && res3 && !res4
    }

    // Runner function with no args to verify all constant checks and equality tests.
    public fun runner(): bool {
        // We check the compile time const expressions by returning them here.
        EQUAL_VECTORS && UNEQUAL_VECTORS && test_equality()
    }
}
//# run 0xCAFE::LargeVectorEquality::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::LargeVectorEquality;

    fun main() {
        // Run the runner function and ignore the boolean result.
        let _ = LargeVectorEquality::runner();
    }
}

// Featurres:
// 4a4fdcd953931b14d0f46289445e9339: Test that the Move compiler can handle constant expressions involving equality comparison of very large vectors (e.g., vectors of over 800 elements).
// df2e3b22b8378d90289589082d35d479: Report diagnostics and exit if any error or higher severity diagnostic is present.
// 03c60ac174e683c8896c630039c7b951: Verify that the equality functions correctly compare u64 values and custom struct instances with a u64 field.
