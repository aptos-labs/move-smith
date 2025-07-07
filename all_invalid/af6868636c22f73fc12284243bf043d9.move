
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;

    // A generic container that can hold any type T
    struct Container<T> has copy, drop, store {
        value: T
    }

    // Example structs for nested structures
    struct InnerStruct has copy, drop {
        a: u64,
        b: bool,
    }

    struct OuterStruct has copy, drop {
        inner: InnerStruct,
        data: vector<u8>,
    }

    // Impure function for testing error messaging (simulating state update)
    public fun impure_func(): u64 {
        // Pretend this modifies state
        42
    }

    // Pure function invoking impure function inside a spec expression (expected to cause error)
    public fun test_impure_in_spec(): bool {
        // This is a pseudo-place for a spec expression that includes impure call
        // In actual test environment, this would trigger a compiler or VM error
        // Here, just a placeholder
        // Note: Move currently doesn't support calling impure functions in specifications
        // so this part is conceptual
        // Let's simulate the test scenario with a comment
        //
        // spec {
        //     assert(impure_func() > 0); // Should produce error: impure call in spec
        // }
        true
    }

    // Function to access nested struct fields via dot notation
    public fun get_nested_fields(outer: OuterStruct): (u64, bool, vector<u8>) {
        let inner_a = outer.inner.a;
        let inner_b = outer.inner.b;
        let data_vec = outer.data;
        (inner_a, inner_b, data_vec)
    }

    // Function to create nested generic structures
    public fun create_nested_generic_structs(): (Container<InnerStruct>, Container<vector<u8>>) {
        let inner_struct = InnerStruct {a: 100, b: true};
        let container_inner = Container<InnerStruct> {value: inner_struct};
        let data_vec = vector::empty<u8>();
        vector::push_back(&mut data_vec, 1);
        vector::push_back(&mut data_vec, 2);
        let container_vec = Container<vector<u8>> {value: data_vec};
        (container_inner, container_vec)
    }

    // Function to examine control flow implications
    public fun analyze_control_flow(vec: vector<u64>): u64 {
        let sum: u64 = 0;
        let len = vector::length(&vec);
        let i: u64 = 0;
        while (i < len) {
            let val = *vector::borrow(&vec, i);
            if (val % 2 == 0) {
                sum = sum + val;
            } else {
                sum = sum + val * 2;
            };
            i = i + 1;
        };
        sum
    }

    // Function combining generic nested structures, impure calls, and control flow
    public fun complex_scenario(): u64 {
        // Create nested generics
        let (inner_container, vec_container) = create_nested_generic_structs();

        // Access nested fields
        let (a_value, b_value, data_vector) = get_nested_fields(OuterStruct {
            inner: InnerStruct {a: inner_container.value.a, b: inner_container.value.b},
            data: vec_container.value,
        });

        // Simulate impure call inside control flow
        let threshold = 50;
        let result = if (a_value > threshold) {
            // Impure call (conceptual, since calling impure in pure VM is typically restricted)
            let impure_value = impure_func();
            // Access data vector length
            let len = vector::length(&data_vector);
            if (impure_value > 40 && len > 1) {
                // Do something
                impure_value + len
            } else {
                impure_value
            }
        } else {
            // Again, impure call
            let val = impure_func();
            val + 10
        };
        result
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::test_impure_in_spec

//# run 0xCAFE::AdvancedFeaturesTest::get_nested_fields --args OuterStruct {inner: InnerStruct {a: 123, b: true}, data: vector [1,2,3]}

//# run 0xCAFE::AdvancedFeaturesTest::create_nested_generic_structs

//# run 0xCAFE::AdvancedFeaturesTest::analyze_control_flow --args vector[1,2,3,4,5,6]

//# run 0xCAFE::AdvancedFeaturesTest::complex_scenario


// Featurres:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 834db50012e317ce95b4a6e911c524dd: Receive detailed error messages when a specification expression calls an impure Move function.
// 73d278c7618650803046349136e36d3d: Access nested names using a dot notation chain.
// 3a743774a3cbecc0df053473a748fa0c: Leverage the ability to obtain the list of successor blocks for each block to understand control flow transitions.
