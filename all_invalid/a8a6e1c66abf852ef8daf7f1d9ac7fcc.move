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
    // Note: In Move, method syntax uses 'impl' for methods
    // But for current Move syntax, define the method as an 'impl' block.
    // To keep the structure as close as possible, define the method as an impl:
    impl<T: copy + drop> Container<T> {
        public fun method(&self): vector<T> {
            self.items
        }
    }

    // Function to instantiate generic struct with specific type and return its length
    public fun instantiate_and_get_length<T: copy + drop>(items: vector<T>): u64 {
        let container = Container { items };
        vector::length(&container.items)
    }
}
