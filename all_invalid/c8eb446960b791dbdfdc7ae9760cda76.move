
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::signer;

    // feature = "custom_comparison"]
    struct MyStruct<T> has copy, drop, store, key {
        value: T
    }

    // info = 42u8]
    struct NoKeyStruct has copy, drop {
        flag: bool
    }

    // derive = "PartialOrd"]
    struct Comparable {
        a: u64,
        b: u64
    }

    // Custom comparison function that can be rewritten by compiler for Comparable
    public fun is_less(x: &Comparable, y: &Comparable): bool {
        if (x.a < y.a) {
            true
        } else if (x.a == y.a) {
            x.b < y.b
        } else {
            false
        }
    }

    public fun create_my_struct_u8(val: u8): MyStruct<u8> {
        MyStruct<u8> { value: val }
    }

    public fun create_my_struct_bool(val: bool): MyStruct<bool> {
        MyStruct<bool> { value: val }
    }

    public fun get_value<T: copy>(s: &MyStruct<T>): T {
        s.value
    }

    public fun check_custom_comparison() {
        let c1 = Comparable { a: 10u64, b: 20u64 };
        let c2 = Comparable { a: 10u64, b: 21u64 };
        let c3 = Comparable { a: 11u64, b: 19u64 };

        assert!(is_less(&c1, &c2), 1);
        assert!(!is_less(&c2, &c1), 2);
        assert!(is_less(&c1, &c3), 3);
        assert!(!is_less(&c3, &c1), 4);
    }
}


//# run 0xCAFE::AdvancedFeatures::check_custom_comparison


//# run 0xCAFE::AdvancedFeatures::create_my_struct_u8 --args 123u8


//# run 0xCAFE::AdvancedFeatures::create_my_struct_bool --args true


// Featurres:
// 4d54e60e788ef2ff56d39867c98f8643: Use custom comparison operations that can be automatically rewritten by the compiler for supported functions.
// 39742c2f0f1f151cd831678e80e663ad: Annotate Move items with assigned attributes with a value, e.g., #[name = value].
// 18337b379384f2c8fe0fb128bd8a8c7c: Declare type parameters for Move struct types
