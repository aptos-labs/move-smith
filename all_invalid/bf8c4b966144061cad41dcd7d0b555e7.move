//# publish
module 0xA550::TestModule {
    // 1. Include only modules with Spec or Use annotations (simulate by including annotations in comments)
    /// @Spec: Module documentation
    /// @Use: Util functions

    // 2. Declare a struct with various visibility modifiers, with a comment about language version
    struct MyStruct has key {
        /// Optional visibility: only allowed if language v2 is enabled
        // Note: Visibility modifiers are ignored in v1, but should be allowed in v2
        pub value: u64,
        optional_data: vector<u8>,
        // Use a type parameter, which should be removed if unused
        unused_type_param: Option<unaddressed>,
    }

    // 3. Configure error reporting - simulate by defining a function that could cause an error
    public fun configure_error_output() {
        // Simulate configuring error output to a specific writer
        // (In actual Move, error output config is not directly settable, so this is illustrative)
        // Assume a fake API call for the test
        error::set_output_writer(b"error_output_writer");
    }

    // 4. Define a spec function with a name prefixed by '$'
    public fun $spec_related_function() {
        // some specification logic
    }

    // 5. Define a function that sets list parsing behavior via passed closures
    public fun parse_list_with_behavior(
        list: vector<u8>,
        continue_f: fn(vector<u8>) -> bool,
        end_f: fn() -> (),
    ) {
        let mut index = 0;
        while index < vector::length(&list) {
            let chunk = vector::slice(&list, index, index + 1);
            if (continue_f)(chunk) {
                index = index + 1;
            } else {
                (end_f)();
                break;
            }
        }
    }

    // 6. Use byte string literals: include a byte string literal
    public fun process_bytes() {
        let bytes: vector<u8> = b"raw_bytes_sequence";
        // process bytes
        let _processed = bytes;
    }

    // 7. Use compiler to identify and remove unused type parameters
    // (simulate struct with unused type parameter; in Move, unused type params are detected)
    struct UnusedGeneric<A> {
        value: u64,
    }

    // 8. Apply unary operators to expressions
    public fun unary_operations() {
        let x = 5;
        let neg_x = -x; // unary minus
        let not_x = !true; // unary not
    }

    //# run 0xA550::TestModule::test_runner
    public fun test_runner() {
        configure_error_output();

        // Call spec function
        $spec_related_function();

        // Set list parsing behavior
        parse_list_with_behavior(
            b"abc",
            // continue_f: continue if byte is 'a' or 'b'
            |slice: vector<u8>| { vector::length(&slice) == 1 && (vector::get(&slice, 0) == b'a' || vector::get(&slice, 0) == b'b') },
            // end_f: do nothing for now
            || {},
        );

        // Process bytes
        process_bytes();

        // Unary operations
        unary_operations();
    }
}