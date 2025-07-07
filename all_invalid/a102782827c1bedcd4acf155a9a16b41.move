
//# publish
module 0xCAFE::ComplexStructs {
    use std::signer;

    // phantom]
    struct PhantomMarker<T> has copy, drop {}

    // copy]
    // store]
    // key]
    struct KeyedStruct<T, U> has copy, drop, store, key {
        a: T,
        b: U,
        marker: PhantomMarker<u8>,
    }

    // store]
    struct OnlyStoreStruct has store {
        u: u64
    }

    // copy]
    // drop]
    // store]
    struct FullAbilityStruct has copy, drop, store {
        x: u8,
        y: u8,
    }

    public fun create_keyed_struct<T, U>(a: T, b: U): KeyedStruct<T, U> {
        KeyedStruct {a, b, marker: PhantomMarker{}}
    }

    public fun create_only_store_struct(val: u64): OnlyStoreStruct {
        OnlyStoreStruct {u: val}
    }

    public fun create_full_ability_struct(x: u8, y: u8): FullAbilityStruct {
        FullAbilityStruct {x, y}
    }
}


//# run 0xCAFE::ComplexStructs::create_keyed_struct --args 7u8 8u8


//# run 0xCAFE::ComplexStructs::create_only_store_struct --args 12345u64


//# run 0xCAFE::ComplexStructs::create_full_ability_struct --args 5u8 6u8


//# publish
module 0xCAFE::NestedControlFlow {
    public fun nested_if_else(a: u8, b: u8): u8 {
        let res = 0u8;
        if (a < 10) {
            if (b < 5) {
                res = a + b;
            } else {
                if (b < 10) {
                    res = a * b;
                } else {
                    res = 255u8;
                };
            };
        } else {
            if (b > 0) {
                res = a - b;
            } else {
                res = 0u8;
            };
        };
        assert!(res < 256, 777);
        res
    }
}


//# run 0xCAFE::NestedControlFlow::nested_if_else --args 3u8 4u8


//# run 0xCAFE::NestedControlFlow::nested_if_else --args 3u8 7u8


//# run 0xCAFE::NestedControlFlow::nested_if_else --args 3u8 11u8


//# run 0xCAFE::NestedControlFlow::nested_if_else --args 11u8 1u8


//# run 0xCAFE::NestedControlFlow::nested_if_else --args 11u8 0u8


//# publish
module 0xCAFE::FunctionTypesTest {
    public fun apply_function(f: |u8|u8, v: u8): u8 {
        f(v)
    }

    public fun runner_default(): u8 {
        let increment: |u8|u8 has copy+drop = |x: u8| { x + 1u8 };
        apply_function(increment, 10u8)
    }

    public fun runner_square(): u8 {
        let square: |u8|u8 has copy+drop = |x: u8| { x * x };
        apply_function(square, 5u8)
    }
}


//# run 0xCAFE::FunctionTypesTest::runner_default


//# run 0xCAFE::FunctionTypesTest::runner_square


// Featurres:
// 493ce8035e7ebc0a810f21e355e065e9: Define struct types with attributes, abilities, type parameters, and layout annotations.
// a891707b80970a1938797437ba7a174b: Verify that nested if-else statements correctly execute and that the function completes without triggering assertions or errors.
// c9eb5099b0242b7001323e1cb5fc6aa7: Create or use function parameters with function-typed values in non-inline functions if the language version is at least 2.2.
