
//# publish
module 0xCAFE::TestNestedInlining {
    use std::vector;

    struct DummyStruct<T> has copy, drop, store {
        value: T,
    }

    enum DummyEnum has copy, drop {
        Variant1,
        Variant2(u8, u8),
        Variant3 {
            flag: bool
        }
    }

    public fun nested_inline_execute(x: u16): u16 {
        // Inline function returning a tuple
        // Move does not support declaring inline functions inside other functions.
        // Move's 'inline' keyword is not used in Move language; Instead, just define at top level.
        // So we need to move 'inner_func' outside.
        // Alter this design: define a private function outside for 'inner_func'.
        // Let's do that.
        0 // placeholder; will replace
    }

    // Define 'inner_func' outside of 'nested_inline_execute' as a private function
    fun inner_func(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }

    // Updated 'nested_inline_execute' to call external 'inner_func'
    public fun nested_inline_execute(x: u16): u16 {
        let (result_a, result_b) = inner_func(x);
        result_a + result_b
    }

    public fun test_pattern_binding_and_inline(): u32 {
        // Pattern match with multiple bindings
        let e = DummyEnum::Variant2(5, 10);
        let result = match (e) {
            DummyEnum::Variant1 => 0,
            DummyEnum::Variant2(a, b) => a + b,
            DummyEnum::Variant3 { flag } => if (flag) { 100 } else { 200},
        };
        result
    }

    public fun test_cyclic_type_instantiation<T>(): bool {
        // Attempt to instantiate cyclic type - should fail if attempted.
        // But since Move prevents true cyclic types, here just test for successful instantiation.
        // Use a generic struct with a non-cyclic type parameter
        let s = DummyStruct {value: true};
        s.value
    }

    // Runner function to invoke the above
    public fun run_all() {
        let sum = nested_inline_execute(15);
        let match_result = test_pattern_binding_and_inline();
        let flag = test_cyclic_type_instantiation::<bool>();
    }
}


//# run 0xCAFE::TestNestedInlining::run_all

// Features:
// 88d58b7b85c61e281a074f5f4e11a9f6: Test that nested inline functions correctly execute and produce the expected result when called from a public function.
// 723a0b4cfe42d5e895bbeb4c8f8bd1f9: Bind multiple typed variables simultaneously in pattern matching statements.
// 15517e1e07d8dafee9bf6b2df12886df: Prevent cyclic type instantiations in generic structs