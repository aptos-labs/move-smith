
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // 1. Test mapping over vector of structs by reference to collect a field
    public fun collect_x_fields(s: vector<S>): vector<u32> {
        let result = vector::empty<u32>();
        let len = vector::length(&s);
        let i = 0;
        while (i < len) {
            let item = vector::borrow(&s, i);
            vector::push_back(&mut result, item.x);
            i = i + 1;
        };
        result
    }

    // 2. Function parameter with explicit `has drop` ability in type annotation
    public fun process_value_with_drop<T: drop + copy>(value: T): T {
        value
    }

    // 3. Implement a custom checker as an external function
    // (Assuming a test external checker function exists; here as a placeholder)
    // In real scenario, Move external checkers are defined outside Move modules, but
    // for illustration, define a dummy function representing it
    public fun check_value(value: u64): bool {
        // placeholder for external check
        value % 2 == 0
    }
}

// Helper struct for test
struct S has copy, drop {
    x: u32,
    y: u32,
}


//# run 0xCAFE::FeatureTest::collect_x_fields --args vector[{x:1, y:2}, {x:3, y:4}]


//# run 0xCAFE::FeatureTest::process_value_with_drop --args 42u64

// No actual external checker call in test; assuming external verification is integrated in the environment.

// Featurres:
// 8819767f4c31f2fc027a4533595af519: Test that mapping over a vector of struct elements by reference allows collecting their fields (keys) into a new vector using generic inline functions.
// 0f396254db82fbef77ab3f222045a6e5: Test that function parameters can specify abilities such as `has drop` directly in their type annotations and still accept values matching the base type.
// 9da50fe09629e3989dcdb6885ffed707: Implement custom checkers as external checkers for Move modules.
