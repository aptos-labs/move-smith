//# publish
module 0xDEADBEEF::TestModule {
    use std::vector;
    use std::error;

    // Function to create a list of value-range pairs by transforming each element
    public fun create_value_range_pairs(start: u64, end: u64): vector<(u64, u64)> {
        let mut pairs = vector::empty<(u64, u64)>();
        let mut current = start;
        while (current <= end) {
            // Add a pair with the current value and its double
            vector::push_back(&mut pairs, (current, current * 2));
            current = current + 1;
        };
        pairs
    }

    // Function to convert module or address references 
    // (simulate by accepting strings and returning concatenated strings)
    public fun convert_reference(ref_str: &str, is_module: bool): vector<u8> {
        if (is_module) {
            // Replace '.' with '::' for modules
            let mut result = vector::empty<u8>();
            let chars = vector::from_bytes(ref_str.as_bytes());
            let len = vector::length(&chars);
            let mut i = 0;
            while (i < len) {
                if (vector::borrow(&chars, i) == b'.') {
                    // replace '.' with '::'
                    vector::push_back(&mut result, b':');
                    vector::push_back(&mut result, b':');
                    i = i + 1;
                } else {
                    vector::push_back(&mut result, vector::borrow(&chars, i));
                    i = i + 1;
                }
            };
            result
        } else {
            // For addresses, simulate converting '.' to '::', for demonstration
            let mut result = vector::empty<u8>();
            let chars = vector::from_bytes(ref_str.as_bytes());
            let len = vector::length(&chars);
            let mut i = 0;
            while (i < len) {
                if (vector::borrow(&chars, i) == b'.') {
                    // replace '.' with '::'
                    vector::push_back(&mut result, b':');
                    vector::push_back(&mut result, b':');
                    i = i + 1;
                } else {
                    vector::push_back(&mut result, vector::borrow(&chars, i));
                    i = i + 1;
                }
            };
            result
        }
    }

    // Function to handle unexpected types
    public fun handle_unexpected_type<T>(): error::Error {
        // For demonstration, we forcibly return an error
        error::new_error(error::EUNEXPECTED, "Unexpected type encountered")
    }

    // Runner function to exercise above functionalities
    public fun run_all() {
        // Demonstrate create_value_range_pairs
        let pairs = create_value_range_pairs(1, 5);
        // For simplicity, no assertions, just calling the function

        // Demonstrate convert_reference for a module
        let module_ref = convert_reference("My.Module.Name", true);
        // Demonstrate convert_reference for an address
        let address_ref = convert_reference("0xDE.AD.BE.EF", false);

        // Demonstrate error handling for unexpected type
        // (This always returns an error; in real code, you'd handle it)
        let _err = handle_unexpected_type<u32>();
    }
}
//# run 0xCAFEBABE::TestModule::run_all