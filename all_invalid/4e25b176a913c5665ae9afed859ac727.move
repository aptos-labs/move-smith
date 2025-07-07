//# publish
module 0xAABBCC::TestStructModification {
    // Struct with public fields
    struct MyStruct {
        value: u64,
        name: vector<u8>,
    }

    // Function to create and return a new struct instance
    public fun create_struct(init_value: u64, init_name: vector<u8>): MyStruct {
        MyStruct {
            value: init_value,
            name: init_name,
        }
    }

    // Function to modify the value field of a mutable reference
    public fun modify_value(s: &mut MyStruct, new_value: u64) {
        s.value = new_value;
    }

    // Runner function to perform the test logic
    public fun run_test(): u64 {
        // Create a struct instance
        let mut s = create_struct(42, b"original".to_vec());
        // Take a copy of the struct
        let s_copy = move s; // move s into s_copy

        // Since s is moved, re-create it for further modification
        let mut s = create_struct(s_copy.value, s_copy.name);

        // Modify s through mutable reference
        modify_value(&mut s, 100);

        // Return the modified value
        s.value
    }
}

//# run 0xAABBCC::TestStructModification::run_test