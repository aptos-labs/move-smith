//# publish
module 0xA550C0DE::docs_reference {
    /// Function to provide documentation URL for a specific checker.
    /// As a placeholder, it prints out the URL with slide anchor.
    public fun show_checker_docs(checker_name: &string) {
        // This is a mock implementation: in a real test, it might print or log the URL.
        // For testing purposes, this could be a no-op or a dummy log.
        // Example URL format: https://checker-docs.com/#<checker_name>
        // Since Move lacks native print, assume that the test environment captures output.
        // Here, just declare the function as a placeholder.
    }
}

//# run
script {
    // Call the documentation URL display function with a specific checker name.
    0xA550C0DE::docs_reference::show_checker_docs("field_accessor");
}
//# publish
module 0xA550C0DE::field_accessor {
    // Struct with mutable fields
    struct MyStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    // A tuple with mixed types
    type MyTuple = (u8, u64, bool);

    // Function to demonstrate accessing the documentation URL for a checker
    public fun show_documentation() {
        // Call the function to display documentation URL for 'field_accessor' checker
        0xA550C0DE::docs_reference::show_checker_docs(&"field_accessor".to_string());
    }

    // Function to mutate struct fields via dot notation
    public fun mutate_struct_fields(s: &mut MyStruct) {
        s.a = 42;
        s.b = true;
    }

    // Function to access tuple fields by positional index
    public fun access_tuple_fields(t: &MyTuple) {
        let first = t.0; // u8
        let second = t.1; // u64
        let third = t.2; // bool

        // Dummy use of the variables to prevent warnings
        // (In actual test, assertions or further operations might be here)
        move_from_first(first);
        move_from_second(second);
        move_from_third(third);
    }

    fun move_from_first(val: u8) {}
    fun move_from_second(val: u64) {}
    fun move_from_third(val: bool) {}

    // A main runner function
    public fun run() {
        // Demonstrate documentation reference
        show_documentation();

        // Create a struct and mutate its fields
        let mut s = MyStruct { a: 0, b: false };
        mutate_struct_fields(&mut s);
        // Fields should now be mutated (tested in VM runs)

        // Create a tuple and access fields
        let t: MyTuple = (255, 123456789, true);
        access_tuple_fields(&t);
    }
}

//# run 0xA550C0DE::field_accessor::run --signers 0xA550C0DE

// Featurres:
// c45f86494ac8a4cb9e559e647068c85c: Reference detailed documentation about a particular checker by directing developers to a URL with the checker name as an anchor.
// 556df3669107a40bdc5951ecbed01061: Mutate fields of structs via dot notation on the left side of assignment (e.g., s.field = value)
// edadf2c9fb9845b59892db51edd0f496: Access tuple fields by positional index using dot notation, such as `my_tuple.0`.
