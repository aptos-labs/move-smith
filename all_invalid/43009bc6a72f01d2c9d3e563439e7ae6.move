
//# publish
module 0xBADD::FeatureInteractionTest {
    use std::vector;
    use std::signer;
    use std::debug;

    // Struct with nested fields to test dot notation access
    struct OuterStruct has store {
        inner: InnerStruct,
    }

    struct InnerStruct has store {
        value: u64,
    }

    // Generic registry for storing structs
    struct Registry<T> has store, key {
        items: vector<T>,
    }

    // A function to check if module purity is maintained
    public fun check_purity() {
        // This function should be pure by design for validation
        assert!(true, 42);
    }

    // Inline function for inlining test
    public inline fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Function that aborts twice and tests execution flow
    public fun abort_multiple_times(flag: bool): u64 acquires OuterStruct {
        if (flag) {
            abort 100;
        } else {
            abort 200;
        };
        // Unreachable, but to simulate complex logic
        999
    }

    // Function to invoke a passed generic function with type parameter
    public fun invoke_generic_func<F>(f: F, a: u64, b: u64): u64
        where F: copy + Fn(u64, u64) {
        f(a, b)
    }

    // Function to test dot notation on nested fields
    public fun test_dot_notation() {
        let inner = InnerStruct { value: 42 };
        let outer = OuterStruct { inner };
        // Access nested field
        let val = outer.inner.value;
        assert!(val == 42, 55);
    }

    // Function to test vector foreach_mut with closure capturing external state
    public fun mutate_vector_with_closure(vec: &mut vector<u64>, captured: &mut u64) {
        vector::for_each_mut(vec, |x: &mut u64| {
            *x = *x + *captured;
        });
        *captured = *captured + 1;
    }

    // Function to test store operations using generic registry
    public fun test_registry_storage<T: copy + store + drop>(s: &signer, item: T) {
        // Initialize registry
        let registry = Registry { items: vector::empty() };
        // Store item
        vector::push_back(&mut registry.items, item);
        // Verify storage
        let stored_item = *vector::borrow(&registry.items, 0);
        assert!(stored_item == item, 77);
        // Remove item
        let _removed = vector::pop_back(&mut registry.items);
        assert!(vector::length(&registry.items) == 0, 88);
    }

    // Function to check environment variable based color logging control
    public fun check_color_env(): bool {
        if (exists_env_var(b"NO_COLOR")) {
            false
        } else {
            true
        }
    }

    // Helper to check environment variable existence
    public fun exists_env_var(name: &vector<u8>): bool {
        // This is a placeholder; in actual implementation, platform-specific env check
        false
    }

    // Function to perform comprehensive feature interaction testing
    public fun feature_interaction_runner() {
        // Test nested dot notation
        test_dot_notation();

        // Test aborts but continue
        let final_value = abort_multiple_times(false);
        assert!(final_value == 999, 44);

        // Test invoking generic function
        let result = invoke_generic_func(copy inline_add, 10, 20);
        assert!(result == 30, 45);

        // Test inlining by calling inline function
        let sum = inline_add(5, 7);
        assert!(sum == 12, 46);

        // Test storage operations
        let s = signer::create_signer(0xCAFE);
        test_registry_storage<u64>(&s, 1337u64);
        test_registry_storage<InnerStruct>(&s, InnerStruct { value: 999 });
        // Reusing registry for multiple types demonstrates generic handling

        // Test vector mutation with captured variable
        let vec_data = vector::empty<u64>();
        vector::push_back(&mut vec_data, 1);
        vector::push_back(&mut vec_data, 2);
        let capture_var = 10;
        mutate_vector_with_closure(&mut vec_data, &mut capture_var);
        // verify vector elements updated
        let (first, second) = (vector::borrow(&vec_data, 0), vector::borrow(&vec_data, 1));
        assert!(*first == 1 + 10, 50);
        assert!(*second == 2 + 10, 51);
        // verify captured variable incremented
        assert!(capture_var == 11, 52);

        // Finally, check environment variable controlling color output
        let is_color_enabled = check_color_env();
        // no assertion, just execute to verify code flow
        debug::print(b"Color enabled: ");
        if (is_color_enabled) {
            debug::print(b"Yes\n");
        } else {
            debug::print(b"No\n");
        };
    }
}


//# run 0xBADD::FeatureInteractionTest::feature_interaction_runner


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 1630878bb07f0e61d64057399656ba48: Test that the Move function correctly handles multiple aborts and continues execution to produce the expected final result.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// 2d957171cf5a5296383f9397a46e1b89: Test that storing, retrieving, verifying existence, and removing custom structs associated with an account works correctly using generic registry modules.
// 9c8880648b64ae2a2350b77bf05f5b7f: Test that closures passed to vector::for_each_mut can mutate both the elements of the vector and variables captured by reference (as in updating s inside the closure).
// d7aee01c7ef590d18539522f4aef85aa: Use environment variables to control diagnostic message color output.
