//# publish
module 0xCAFE::Vector {
    // INTENTIONALLY shadows 0x1::vector when shadowing is enabled

    // A function that demonstrates dependency on the real 0x1::vector if not shadowed
    public fun len<T>(v: vector<T>): u64 {
        // A simple length function, mirrors 0x1::vector::length for dependency ordering
        let x = 100u64;
        let y = 200u64;
        x + y + 1
    }
}

//# publish
module 0xCAFE::DepOnVector {
    // This module does not import or call 0x1::vector or 0xCAFE::Vector,
    // but it uses a function signature that takes or returns a vector type,
    // forcing vector to be in its dependency closure.

    public fun take_vec(v: vector<u8>): u64 {
        // Just "uses" vector indirectly
        let _z = &v;
        17
    }

    // return type omitted, should default to 'unit'
    public fun do_nothing() {
        // nothing
    }

    public fun runner() {
        let x = take_vec(vector[]);
        let _ = x;
        do_nothing();
    }
}

//# run 0xCAFE::DepOnVector::runner --signers 0xCAFE

//# publish
module 0xCAFE::ShadowTest {
    // Uses Vector::len which should resolve to 0xCAFE::Vector if shadowing is allowed.

    public fun test_shadow() : u64 {
        // This will succeed only if 0xCAFE::Vector is shadowing 0x1::vector
        Vector::len(vector[7u8, 8u8])
    }

    public fun test_return_unit() {
        // This function omits a return value, defaults to unit
        let _ = test_shadow();
        // unit returned implicitly
    }

    public fun runner() {
        let result = test_shadow();
        let _ = result;
        test_return_unit();
    }
}

//# run 0xCAFE::ShadowTest::runner --signers 0xCAFE

//# run
script {
    fun main() {
        // A function with no return type declaration, should return unit.
        let v = vector[1u8, 2u8, 3u8];
        let _ = v;
        // End of script, implicitly returning unit
    }
}

// Featurres:
// bcb944831ff45a6adc5346b89680bf28: Ensure modules outside the `vector` dependency closure implicitly depend on the `vector` module for correct dependency ordering.
// 92c9bad335d82c6987dd46e45a072800: Shadow library modules with source modules when allowed by the compiler flags.
// b26007bf99fc1db673896c15dfcbf105: Specify the return type of functions, defaulting to 'Unit' if not explicitly provided.
