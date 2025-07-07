module 0xCAFE::BindingTest {
    use std::vector;
    use 0xCAFE::MyModule;

    // Remove invalid alias declarations; Move 'use' statements and access module members directly
    // Instead of aliasing, directly reference S and E from MyModule

    // Function to create bindings for a list of u8 values
    public fun create_bindings(values: vector<u8>): vector<(&u8, &u8)> {
        let bindings = vector::empty<(&u8, &u8)>();
        let len = vector::length(&values);
        let i = 0;
        while (i < len) {
            // create references to each element in the vector
            let val_ref = &vector::borrow(&values, i);
            // For demonstration, bind to the same value's reference twice
            vector::push_back(&mut bindings, (val_ref, val_ref));
            i = i + 1;
        };
        bindings
    }

    // Function to demonstrate binding list to list of lvalues
    public fun bind_list_to_lvalues() {
        let values = vector::empty<u8>();
        vector::push_back(&mut values, 10u8);
        vector::push_back(&mut values, 20u8);
        vector::push_back(&mut values, 30u8);

        let bindings = create_bindings(values);
        // bindings is a vector of pairs of references to values
        let _ = bindings;
    }

    // Function to use '&' to define references to fields in a struct
    public fun reference_struct_fields() {
        let s = 0xCAFE::MyModule::S {x: 42, y: 99};
        let x_ref: &u32 = &s.x;
        let y_ref: &u32 = &s.y;

        // Use the references to read the values
        let x_value = *x_ref;
        let y_value = *y_ref;

        // Create another struct instance with references
        let _struct_refs = (x_ref, y_ref);
        let _ = (x_value, y_value);
    }

    // Function to define module alias and access members
    // Instead of aliasing, qualify with the module name
    public fun use_module_members() {
        // Access E::V2 directly
        let e_v2 = 0xCAFE::MyModule::E::V2(1, 2);
        let match_value = match e_v2 {
            0xCAFE::MyModule::E::V1 => 1,
            0xCAFE::MyModule::E::V2(x, y) => x + y,
            0xCAFE::MyModule::E::V3 { a } => if (a) { 2 } else { 3 },
        };
        // match_value would be 3
        let _ = match_value;

        // Instantiate struct S directly
        let s_instance = 0xCAFE::MyModule::S {x: 5, y: 10};
        let _ = s_instance;
    }
}


//# run 0xCAFE::BindingTest::bind_list_to_lvalues

//# run 0xCAFE::BindingTest::reference_struct_fields

//# run 0xCAFE::BindingTest::use_module_members