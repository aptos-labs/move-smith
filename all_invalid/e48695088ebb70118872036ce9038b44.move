// Address block outside modules or scripts
address 0x1 {
    // Empty address block for example purposes
}

 //# publish
module 0x1::test_module {
    // Struct definition
    struct MyStruct {
        value: u64,
    }

    // Function to get the value of the struct
    public fun get_value(s: &MyStruct): u64 {
        s.value
    }

    // Function to set the value of the struct
    public fun set_value(s: &mut MyStruct, new_value: u64) {
        s.value = new_value;
    }

    // Function to test assigning a local copy and modifying through mutable reference
    public fun test_modify_struct() {
        let mut s = MyStruct { value: 10 };
        // Assign local copy
        let mut s_local = s;
        // Modify through mutable reference
        set_value(&mut s_local, 20);
        // Assert that the local copy's value is updated
        assert(get_value(&s_local) == 20, 0);
        // Assert that original struct 's' remains unchanged
        assert(get_value(&s) == 10, 1);
        // Share the modified value back to original
        s = s_local;
        // Final assertion
        assert(get_value(&s) == 20, 2);
    }

    // Function to compute an axiom with optional type parameters, for example purposes
    // Using a type parameter to demonstrate optional typing
    public fun axiom<T: copy + keyof>(x: T): bool {
        // Placeholder: the constraint (T: copy + keyof) is just illustrative
        true
    }

    // Runner function to call the test
    public fun run_tests() {
        test_modify_struct();
        // Call axiom with an example argument
        let _ = axiom<u64>(5);
    }
}

 //# run 0x1::test_module::run_tests