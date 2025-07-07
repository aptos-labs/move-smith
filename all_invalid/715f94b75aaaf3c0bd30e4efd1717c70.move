//# publish
module 0xCAFE::FeatureTest {
    // 1. Declare structs with optional attributes / doc comments
    /// This is a Point struct with two fields.
    struct Point<phantom T: copy, Phantom U> has copy, drop, store, key; {
        /// x coordinate
        x: u64,
        /// y coordinate
        y: u64,
    }

    // Phantom attributes, semicolon after ability set
    struct Wrapper<V, phantom PhantomW> has store, drop; {
        val: V,
    }

    /// An enum-style struct using field attributes
    struct OptionLike<phantom E, V> has drop; {
        present: bool,
        /// Only valid if `present` is true
        value: V,
    }

    // Function that takes multiple type parameters and does something generic
    public fun make_point<T: copy, U>(x: u64, y: u64): Point<T, U> {
        Point { x, y }
    }

    // Generic function using type params in Wrapper
    public fun wrap_val<V>(val: V): Wrapper<V, u8> {
        Wrapper { val }
    }

    public fun make_option<V: copy>(val: V): OptionLike<u8, V> {
        OptionLike { present: true, value: val }
    }

    // Entry point to test creation and copy of struct with abilities
    public fun run_demo() {
        let p = Self::make_point<u8, u64>(10, 20);
        let _p_copy = copy p; // test copy ability
        let w = Self::wrap_val<u64>(100);
        let _ = w;
        let opt_v = Self::make_option<u64>(777);
        let _ = opt_v;
    }
}
//# run 0xCAFE::FeatureTest::run_demo --signers 0xCAFE

//# run
script {
    use 0xCAFE::FeatureTest;

    fun main() {
        let pt = FeatureTest::make_point<u8, bool>(1, 25);
        let wp = FeatureTest::wrap_val<u128>(10);
        let opt = FeatureTest::make_option<u16>(255);
        let _ = pt;
        let _ = wp;
        let _ = opt;
    }
}

// Featurres:
// 5f1b6ce5fd8d403c37036be57af723e0: Declare structs with optional attributes in your Move modules.
// 01e536d50522315aa5fd12654ac3bde0: Use a semicolon to terminate postfix ability declarations when present.
// da67a855c6357f72934f12020e1bde4a: Specify multiple type parameters separated by commas within the angle brackets.
