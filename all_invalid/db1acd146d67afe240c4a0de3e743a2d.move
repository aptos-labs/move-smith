
//# publish
module 0xC0DE::TargetModule {
    use std::vector;

    // A simple friend function to be called from test module
    public(friend) fun process_tuple_structs(data: (u8, u16), s: StructWithTypeParameter<(u8, u16)>) {
        // This function might perform processing; for test, just assert data allows access
        assert!(data.0 <= 255, 0);
        assert!(data.1 <= 65535, 1);
        assert!(vector::length(&vector::empty<u8>()) == 0, 2);
        // mutate the struct's field via creating a new struct
        let _s = s;
    }

    // Define a struct with multiple type params
    struct StructWithTypeParameter<T> has copy, drop, store {
        field: T
    }

    // A friend function that takes nested complex data
    public(friend) fun handle_complex_data(
        nested_tuple: ((u8, (u16, bool)), (u32, vector<u8>)), 
        complex_struct: StructWithTypeParameter<((u8, u16), u32)>
    ) {
        // For validation, check types
        assert!(nested_tuple.0.1.1 == 0, 3);
        assert!(!nested_tuple.0.1.1, 4);
        assert!(complex_struct.field.1 == 0, 5);
    }
}


//# run 0xCAFE::ComplexDataTest::test_complex_module_access
//# publish
module 0xC0DE::ComplexDataTest {
    // Import TargetModule with alias for clarity
    use 0xC0DE::TargetModule as TM;

    // Define a wrapper function to test the friend functions
    public fun run_tests() {
        // Prepare nested complex data
        let nested_tuple = (
            (5u8, (123u16, false)),
            (456u32, vector::empty<u8>())
        );
        // Build a struct with nested tuple
        let complex_struct = TM::StructWithTypeParameter<((u8, u16), u32)> {
            field: ((7u8, 234u16), 789u32)
        };

        // Call friend functions via the module alias
        TM::process_tuple_structs(nested_tuple, complex_struct);
        TM::handle_complex_data(nested_tuple, complex_struct);
    }
}


//# run 0xC0DE::ComplexDataTest::run_tests


// Featurres:
// 0496ae800bd35e891a22b97a0664b057: Use 'public(friend)' functions to allow controlled module access via friend declarations.
// 2611c2780d4d6685568fe5fc8bca46c8: Incorporate nested tuple and struct types to construct complex data structures with multiple type parameters.
// ce8f445c59f9734a04ad03d5decde9da: Use 'use' declarations to import entire modules with optional aliasing.
