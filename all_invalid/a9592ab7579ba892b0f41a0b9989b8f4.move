//# publish
module 0x1::test_module {
    // Define a struct with multiple fields
    struct MyStruct has copy, drop, store {
        a: u64,
        b: bool,
        c: address,
    }

    // Function to test unpacking syntax with braces
    public fun unpack_fields(s: &MyStruct): (u64, bool, address) {
        // Using destructure to unpack fields
        let MyStruct { a, b, c } = *s;
        (a, b, c)
    }

    // Function to report intersection error
    public fun report_intersection(file1: vector<u8>, file2: vector<u8>) {
        // Dummy function body; actual error reporting handled by compiler
        let _ = (file1, file2);
    }

    // Declare friend modules to grant access
    // (In Move, 'friend' modules are generally specified at module declaration or via special features)
    // Move currently does not have explicit 'friend', but can simulate via visible functions
}

//# run
script {
    use 0x1::test_module;

    fun main() {
        // Initialize a struct
        let s = test_module::MyStruct { a: 42, b: true, c: @0xA55A5A };
        // Test unpacking syntax
        let (val_a, val_b, val_c) = test_module::unpack_fields(&s);
        // Execute report_intersection with dummy file lists (simulate intersection)
        let file1 = b"file1.move";
        let file2 = b"file1.move"; // Same file to simulate intersection
        test_module::report_intersection(vector::from_bytes(file1), vector::from_bytes(file2));
        // No assertions; focus on compiler and VM execution
    }
}