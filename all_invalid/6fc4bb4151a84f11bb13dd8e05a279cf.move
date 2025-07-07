
//# publish
module 0xDEAD::CompilerEdgeCaseTest {
    use std::vector;

    // Define a generic container struct for testing
    struct Container<T> has copy, drop, store {
        item: T,
    }

    // A simple struct with nested fields for complex types
    struct NestedStruct has copy, drop, store {
        a: u8,
        b: vector<u8>,
        c: Container<u16>,
    }

    // Test function to invoke deprecated generics syntax and verify warnings handling
    public fun test_deprecated_generics<T: copy + drop>(obj: Container<T>) {
        // Deprecated syntax: using :: with explicit generic args (simulate warning)
        // Move 2.2+ issues warning for this; here we invoke it intentionally
        let _deprecated_syntax_incorrect = obj.method::<T>(); // deliberate usage
        // Current syntax
        let _correct_syntax = obj.method(); // valid
    }

    // Define a helper method for Container to invoke
    public fun Container<T>::method(self: &Container<T>): T {
        self.item
    }

    // Function to test impure functions within spec expressions and diagnostics
    public fun impure_in_spec(expr: bool): u8 {
        let val = if (expr) {
            // Impure op: calling a function that reads global state
            impure_read()
        } else {
            42u8
        };
        val
    }

    // Impure function simulating reading global state (not allowed in spec)
    public fun impure_read(): u8 {
        // For test purposes, this is an impure function
        7u8
    }

    // Test inheritance of generic containers with nested types
    public fun create_nested_structs() {
        let nested = NestedStruct {
            a: 1,
            b: vector::empty<u8>(),
            c: Container { item: 65535u16 },
        };

        // Use deprecated generic syntax
        let _ = NestedStruct::<vector<u8>>.b;
        // Use current
        let _ = nested.b;

        // Initialize complex container with nested types
        let complex_container = Container {
            item: nested.c,
        };
    }

    // Use referencing syntax in initial component
    // Here simulate referencing either address or identifier
    public fun create_reference(addr_or_id: &vector<u8>): vector<u8> {
        // For test, just clone the vector
        vector::clone(addr_or_id)
    }

    // Inline function with inlining enabled, for test
    public inline fun inline_add(x: u64, y: u64): u64 {
        x + y
    }

    // Closure capturing references, passed to inline generic function
    public fun call_closure<P: copy + drop>(closure: &|P| P, val: P): P {
        closure(val)
    }

    // Generic inline function accepting closure
    public inline fun process_with_closure<P: copy + drop>(func: &|P| P, param: P): P {
        func(param)
    }

    // Function to test referencing syntax, inline functions, and closures
    public fun test_complex_features() {
        // Create a vector referencing data
        let data_vec = vector::empty<u8>();
        vector::push_back(&mut data_vec, 10);
        vector::push_back(&mut data_vec, 20);

        // Create reference to vector (simulate referencing with a name)
        let ref_vec = create_reference(&data_vec);

        // Call inline add function
        let sum = inline_add(100u64, 200u64);
        // Define a closure capturing references
        let closure = &|input: u8| -> u8 {
            // Use referenced vector
            *vector::borrow(&ref_vec, 0) + input
        };
        // Call process with closure
        let result = process_with_closure(closure, 3u8);
        // Use closure with generic
        let _ = call_closure(closure, 7u8);
    }
}


//# run 0xDEAD::CompilerEdgeCaseTest::test_deprecated_generics --args
// This test will attempt to invoke deprecated generics syntax and verify diagnostics


//# run 0xDEAD::CompilerEdgeCaseTest::impure_in_spec --args true
// This executes impure function within spec, expecting detailed error in diagnostics


//# run 0xDEAD::CompilerEdgeCaseTest::create_nested_structs


//# run 0xDEAD::CompilerEdgeCaseTest::test_complex_features


// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 834db50012e317ce95b4a6e911c524dd: Receive detailed error messages when a specification expression calls an impure Move function.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// e7ffd08d565ddffe6a05ad674e354d0e: Reference items using a syntax that allows either an address or an identifier as the first component
// 4625b3aabf3f1e50655d70fe22b574f2: Use the inlining process to optimize code by replacing calls to inline functions with their bodies.
// 2b7c242bf6cecc00abda17f7565d11f5: Test that closures with references can be passed to and invoked from an inline generic function.
