
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
        _value;
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


//# run 0xCAFE::DeserializedModule::process_wrapper --args 0xCAFE::DeserializedModule::create_wrapper --type-args u64 --args 123

// In the above, note the correct way to pass arguments in CLI is:
// --args <value> --type-args <types>
// So for create_wrapper, we add --type-args u64 and --args 123
// For process_wrapper, we pass the module call with --args as the wrapper instance with type argument specified.



//# publish
module 0xCAFE::GenericWithComplexInteractions {
    use 0xCAFE::GenericInteractionTest;
    use 0xCAFE::DeserializedModule;

    // Function that creates a vector of generic containers
    public fun generic_vector_interaction(): vector<Container<u8>> {
        let c1 = GenericInteractionTest::create_container<u8>(10);
        let c2 = GenericInteractionTest::create_container<u8>(20);
        let vec = vector::empty<Container<u8>>();
        vector::push_back(&mut vec, c1);
        vector::push_back(&mut vec, c2);
        vec
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
