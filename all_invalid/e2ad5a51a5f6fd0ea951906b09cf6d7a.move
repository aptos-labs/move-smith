
//# publish
module 0xCAFE::GenericInteractionTest {
    use std::vector;

    // A generic struct to test deserialization and generic syntax
    struct Container<T> has copy, drop, store {
        value: T
    }

    public fun create_container<T>(val: T): Container<T> {
        Container { value: val }
    }

    // Function using deprecated syntax :: with a generic function
    public fun call_generic_deprecated<T>(c: Container<T>): T {
        // Here we deliberately use the deprecated syntax
        // expected warning in Move 2.2+: "deprecated syntax `::` for generics"
        c.method::<T>()
    }

    // Helper function to invoke the method (simulate method with generic param)
    public fun method<T>(self: &Container<T>): T {
        self.value
    }

    // Function to load a module from a file (simulated by inline code)
    // In actual tests, modules are loaded via compile, so simulate by preparing a compiled module.
    public fun load_and_invoke_generic() {
        // This is a placeholder: in actual tests, this would involve deserializing a compiled module,
        // but for simplicity, we call create_container and method directly.
        let c = create_container<u64>(42);
        // Call deprecated syntax function
        let _value = call_generic_deprecated<u64>(c);
        _value
    }
}


//# run 0xCAFE::GenericInteractionTest::load_and_invoke_generic


//# publish
module 0xCAFE::DeserializedModule {
    // A mock module that is supposed to be loaded from a file
    // This module contains functions with generics and uses deprecated syntax

    use std::vector;

    // Generic struct inside deserialized module
    struct Wrapper<T> has copy, drop, store {
        data: T
    }

    public fun create_wrapper<T>(val: T): Wrapper<T> {
        Wrapper { data: val }
    }

    public fun process_wrapper<T>(w: &Wrapper<T>): T {
        w.data
    }
}


//# run 0xCAFE::DeserializedModule::create_wrapper --args 123u64

//# run 0xCAFE::DeserializedModule::process_wrapper --args 0xCAFE::DeserializedModule::create_wrapper
// Note: In a real test, you'd deserialize a binary module and invoke its functions.
// For demonstration, we simulate using functions directly.


//# publish
module 0xCAFE::GenericWithComplexInteractions {
    use 0xCAFE::GenericInteractionTest;
    use 0xCAFE::DeserializedModule;

    // Function that creates a vector of generic containers
    public fun generic_vector_interaction(): vector<Container<u8>> {
        let c1 = GenericInteractionTest::create_container<u8>(10);
        let c2 = GenericInteractionTest::create_container<u8>(20);
        vector::empty<Container<u8>>()
            |> vector::push_back(&mut _, c1)
            |> vector::push_back(&mut _, c2)
    }

    // Function that calls a generic method with deprecated syntax
    public fun call_deprecated_generic(): u8 {
        let c = GenericInteractionTest::create_container<u8>(55);
        let val = GenericInteractionTest::call_generic_deprecated<u8>(c);
        val
    }

    // Function that invokes functions in deserialized module with generics
    public fun invoke_deserialized_module(): u64 {
        let w = DeserializedModule::create_wrapper<u64>(999);
        let result = DeserializedModule::process_wrapper(&w);
        result
    }
}


//# run 0xCAFE::GenericWithComplexInteractions::generic_vector_interaction

//# run 0xCAFE::GenericWithComplexInteractions::call_deprecated_generic

//# run 0xCAFE::GenericWithComplexInteractions::invoke_deserialized_module


// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
