
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // 1. Test mapping over vector of structs by reference to collect a field
    public fun collect_x_fields(s: vector<S>): vector<u32> {
        let result = vector::empty<u32>();
        let len = vector::length(&s);
        let i = 0;
        while (i < len) {
            let item_ref = vector::borrow(&s, i);
            vector::push_back(&mut result, item_ref.x);
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



//# run 0xCAFE::FeatureTest::collect_x_fields --args vector[ { x: 1, y: 2 }, { x: 3, y: 4 } ]


//# run 0xCAFE::FeatureTest::process_value_with_drop --args 42u64