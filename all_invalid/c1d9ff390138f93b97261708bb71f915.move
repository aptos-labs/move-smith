
//# publish
module 0xCAFE::GenericSyntaxTest {
    use std::vector;

    // Example struct to test nested generics and serialization/deserialization
    struct Container<T> has copy, drop, store {
        items: vector<T>,
    }

    // Function that uses deprecated syntax: `obj.method::<T>()`
    public fun use_deprecated_generic_syntax<T: copy + drop>(x: vector<T>): vector<T> {
        // Wrap in a struct to simulate calling method with deprecated syntax
        let container = Container { items: x };
        // simulate method call with deprecated syntax
        container.method::<T>()
    }

    // Dummy function that mimics a method in deprecated syntax
    public fun Container<T: copy + drop>::method(): vector<T> {
        self.items
    }

    // Function to instantiate generic struct with specific type and return its length
    public fun instantiate_and_get_length<T: copy + drop>(items: vector<T>): u64 {
        let container = Container { items };
        vector::length(&container.items)
    }
}

// Save the module bytecode; in real scenario, compile and save bytecode to file.


//# run 0xCAFE::GenericSyntaxTest::use_deprecated_generic_syntax --args 0u8 1u8 2u8


//# run 0xCAFE::GenericSyntaxTest::instantiate_and_get_length --args 10u64


// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
