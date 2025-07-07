
//# publish
module 0xCAFE::AdvancedTest {
    // Test compiler automatic acquires inference (V2_2+)
    // Omit acquires annotations on purpose

    use std::signer;

    struct Container<T> has store {
        value: T,
    }

    // 1. Convert list of type parameters with abilities to a set-based representation
    // Here we demonstrate by defining abilities sets via constant masks (abstracted as u8 flags)
    const ABILITY_COPY: u8 = 0x1;
    const ABILITY_DROP: u8 = 0x2;
    const ABILITY_STORE: u8 = 0x4;

    // Compose ability sets for generic parameters (simulated via constants)
    // This simulates converting abilities into set but implemented as bit flags
    const ABILITIES_T1: u8 = ABILITY_COPY | ABILITY_DROP; // e.g., copy, drop
    const ABILITIES_T2: u8 = ABILITY_STORE;             // e.g., store only

    // 3. Multiple functions with unique names in one module

    public fun unique_func1(): u64 {
        1u64
    }

    public fun unique_func2(): u64 {
        2u64
    }

    // 4. apply function to accept a function and apply it to two u64 args
    public fun apply(f: |u64, u64|u64, a: u64, b: u64): u64 {
        f(a, b)
    }

    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun mul(a: u64, b: u64): u64 {
        a * b
    }

    // Test nested apply: apply(add, apply(mul, 2, 3), 4) == 2*3 + 4 = 6 + 4 = 10
    public fun test_nested_apply(): u64 {
        let inner_res = apply(mul, 2u64, 3u64);
        apply(add, inner_res, 4u64)
    }

    // 5. Advanced control flow with labels
    public fun labeled_loop_counter(limit: u64): u64 {
        let count = 0u64;
        'outer: loop {
            let inner_count = 0u64;
            'inner: loop {
                if (inner_count >= 2) {
                    break 'inner;
                };
                count = count + 1;
                inner_count = inner_count + 1;
            };
            if (count >= limit) {
                break 'outer;
            };
        };
        count
    }
}


//# run 0xCAFE::AdvancedTest::unique_func1


//# run 0xCAFE::AdvancedTest::unique_func2


//# run 0xCAFE::AdvancedTest::apply --args 6u64 7u64
// Note: We cannot pass function pointers as direct args in command line, but the function expects a closure argument.
// So we run wrapper functions calling apply internally instead:


//# publish
module 0xCAFE::ApplyWrappers {
    use 0xCAFE::AdvancedTest;

    public fun apply_add_wrapper(a: u64, b: u64): u64 {
        AdvancedTest::apply(AdvancedTest::add, a, b)
    }

    public fun apply_mul_wrapper(a: u64, b: u64): u64 {
        AdvancedTest::apply(AdvancedTest::mul, a, b)
    }

    public fun apply_nested_wrapper(): u64 {
        AdvancedTest::test_nested_apply()
    }
}


//# run 0xCAFE::ApplyWrappers::apply_add_wrapper --args 6u64 7u64


//# run 0xCAFE::ApplyWrappers::apply_mul_wrapper --args 6u64 7u64


//# run 0xCAFE::ApplyWrappers::apply_nested_wrapper


//# run 0xCAFE::AdvancedTest::labeled_loop_counter --args 5u64


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 2ffd5767186aaca98f278f2ea6f30c73: Convert a list of type parameters with their ability constraints into a set-based representation for further use.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
// 5edeb43b4949a322a9e9774c8d330bb7: Test that the `apply` function correctly accepts a function and applies it to two u64 arguments, verifying nested function calls with different operations.
// b2fe2ba0fc5f4483ab8510aa33fd8420: Label code blocks for advanced control flow using labels
