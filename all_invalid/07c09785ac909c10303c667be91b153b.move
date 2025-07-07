
//# run 0xCAFE::MyModule::f1 --args 5u8 false

//# run 0xCAFE::MyModule::f2 --args 15u16

//# publish
module 0xCAFE::DebugHelpers {
    use std::vector;

    // Function to format the initialization state of local variables for debugging
    public fun format_vars_for_debugging(x: u32, y: bool, z: u16): vector<u8> {
        let result = vector::empty<u8>();
        // Append string "x: " (assuming ASCII values for simplicity)
        vector::push_back(&mut result, b'x');
        vector::push_back(&mut result, b':');
        vector::push_back(&mut result, b' ');
        // Append x value
        let x_bytes = u32::to_bytes(x);
        vector::append(&mut result, &x_bytes);

        // Append comma separator
        vector::push_back(&mut result, b',');
        vector::push_back(&mut result, b' ');

        // Append string "y: "
        vector::push_back(&mut result, b'y');
        vector::push_back(&mut result, b':');
        vector::push_back(&mut result, b' ');
        // Append y value (converted to 1 or 0)
        let y_value: u8 = if y { 1 } else { 0 };
        vector::push_back(&mut result, y_value);

        // Append comma separator
        vector::push_back(&mut result, b',');
        vector::push_back(&mut result, b' ');

        // Append string "z: "
        vector::push_back(&mut result, b'z');
        vector::push_back(&mut result, b':');
        vector::push_back(&mut result, b' ');
        // Append z value
        let z_bytes = u16::to_bytes(z);
        vector::append(&mut result, &z_bytes);

        result
    }

    // Function to rewrite specifications as code transformations
    // We'll create a function that takes an address and module name and
    // retrieves the module identifier as a string (simulate)
    public fun get_module_identifier(address: address, module_name: vector<u8>): vector<u8> {
        // In real implementation, would look up module id, here fake by concatenation
        let id = vector::empty<u8>();
        vector::append(&mut id, &address_to_bytes(address));
        vector::push_back(&mut id, b':');
        vector::append(&mut id, &module_name);
        id
    }

    // Helper to convert address to bytes
    fun address_to_bytes(addr: address): vector<u8> {
        // Fake conversion: fill with repeated pattern, assuming 16-byte address
        let bytes = vector::empty<u8>();
        let count = 16;
        let i = 0;
        while (i < count) {
            vector::push_back(&mut bytes, 0xAB);
            i = i + 1;
        }
        bytes
    }
}


//# run 0xCAFE::DebugHelpers::format_vars_for_debugging --args 42u32 true 300u16

//# run 0xCAFE::DebugHelpers::get_module_identifier --args 0xCAFE "MyModule"
