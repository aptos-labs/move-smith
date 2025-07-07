
//# publish
module 0xCAFE::AdditionTest {
    public fun add_u8_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 to test fixed return after computation
        42u8
    }

    struct Wrapper<T: copy + drop> has copy, drop {
        value: T
    }

    struct NestedWrapper<T: copy + drop> has copy, drop {
        inner: Wrapper<T>
    }

    struct MultiAbility<T: copy + drop + store> has copy, drop, store {
        data: T
    }

    public fun create_wrappers(): (Wrapper<u8>, NestedWrapper<u8>, MultiAbility<u8>) {
        let w = Wrapper<u8> { value: 7u8 };
        let nw = NestedWrapper<u8> { inner: w };
        let ma = MultiAbility<u8> { data: 9u8 };
        (w, nw, ma)
    }
}


//# run 0xCAFE::AdditionTest::add_u8_and_return_specific --args 10u8 20u8


//# run 0xCAFE::AdditionTest::create_wrappers



//# publish
module 0xCAFE::ScriptConvertedModule {
    // This module simulates a former script logic but moved into module to test
    // ability to convert user scripts into modules when experiment enabled

    public fun test_function_that_would_be_in_script(x: u8, y: u8): u8 {
        x * y + 1u8
    }
}


//# run 0xCAFE::ScriptConvertedModule::test_function_that_would_be_in_script --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 0a38877e9df2d5e826a5ae54b1bf6abf: Convert scripts into modules when the experiment for attaching compiled modules is enabled.
