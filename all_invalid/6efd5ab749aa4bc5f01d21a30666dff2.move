
//# publish
module 0xBADD::TestModule {
    use std::vector;

    struct PhantomStruct<T> has copy, drop {
        data: u8,
        phantom_marker: bool,
    }

    // Function to demonstrate that T is phantom
    public fun create_phantom_struct<T>(): PhantomStruct<T> {
        let p = PhantomStruct<T> { data: 42, phantom_marker: true };
        p
    }

    // Function to generate string representation of ModuleId
    public fun generate_module_id_string(address: address, module_name: vector<u8>): vector<u8> {
        // Convert address to string
        let address_str = b"0x";
        let addr_bytes = address_to_bytes(address);
        let result = vector::empty<u8>();
        vector::extend(&mut result, address_str);
        vector::extend(&mut result, &addr_bytes);
        result
    }

    // Helper to convert address to bytes as string
    public fun address_to_bytes(addr: address): vector<u8> {
        let bytes = address::to_bytes(addr);
        let hex_string = vector::empty<u8>();
        let hex_chars = b"0123456789abcdef";

        let len = 16;
        let i = 0;
        while (i < len) {
            let byte = *vector::borrow(&bytes, i);
            let high_nibble = byte / 16;
            let low_nibble = byte % 16;
            vector::push_back(&mut hex_string, *vector::borrow(&hex_chars, high_nibble));
            vector::push_back(&mut hex_string, *vector::borrow(&hex_chars, low_nibble));
            i = i + 1;
        };
        hex_string
    }

    // Function to avoid complex sequence in binary operation operands
    public fun binary_op_with_avoid_sequence(x: u8, y: u8, z: u8): u8 {
        let temp1 = x + y;
        // Instead of writing (temp1 + z) directly, use a variable
        let sum = temp1 + z;
        sum
    }

    // Runner function to exercise the above features
    public fun run_tests() {
        let _phantom_struct: PhantomStruct<u64> = create_phantom_struct<u64>();
        let addr_str = generate_module_id_string(@0xBADD, b"TestModule");
        // Assume address::to_bytes is available
        let _ = address_to_bytes(@0xBADD);
        let result = binary_op_with_avoid_sequence(2, 3, 4);
        // result is used to validate
        assert!(result == 9, 999);
    }
}


//# run 0xBADD::TestModule::run_tests


// Featurres:
// 442e0dcdfd33d8af2b7856544d547ff0: Mark struct type parameters as phantom using is_phantom
// 08ca6158f2514ddbc055c5bb62f852a9: Generate a string representation of a ModuleId using a named address if available, otherwise use the numerical address.
// 8b353d0c6605264224828047f87c28a2: Avoid placing sequences with multiple expressions inside the operands of binary operations, or rewrite code to eliminate such sequences to ensure clearer evaluation order.
