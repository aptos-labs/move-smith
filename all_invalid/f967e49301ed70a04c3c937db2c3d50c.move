
//# publish
module 0xBADD::TestModule {
    // Struct within module
    struct InnerStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    public fun create_inner_struct(a: u64, b: bool): InnerStruct {
        let inner = InnerStruct {a, b};
        inner
    }

    // Function to test variable assignment and assertion
    public fun foo(x: u64): u64 {
        let y = 10u64; // assignment to local variable
        let z = y + x;
        let y = y + 1; // reassign y
        z + y
    }

    // Runner function for `foo` with test assertion
    public fun test() {
        let result = foo(5u64);
        assert!(result == 16, 999);
    }
}


//# run 0xBADD::TestModule::create_inner_struct --args 42u64 true


//# run 0xBADD::TestModule::foo --args 7u64


//# run 0xBADD::TestModule::test


// Featurres:
// c27969d4f35a7486332f9ed9bcca96fc: Check for assignments to local variables that are never used.
// 2e4204472b7cb57f983c4c052ee637ea: Define structs within a module.
// f7287dfab43402d782421e72dd15fe9a: Test that the function `foo` correctly assigns a new value to a mutable local variable and that the `test` function assert correctly verifies the result.
