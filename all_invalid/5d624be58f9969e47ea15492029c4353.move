
//# publish
module 0xCAFE::NativeExample {

    native public fun native_add(x: u64, y: u64): u64;

    public fun add_two_numbers(x: u64, y: u64): u64 {
        native_add(x, y)
    }

    native public fun native_no_args(): u8;

    public fun call_native_no_args(): u8 {
        native_no_args()
    }
}



//# run 0xCAFE::NativeExample::add_two_numbers --args 10u64 20u64



//# run 0xCAFE::NativeExample::call_native_no_args




//# publish
module 0xCAFE::ModuleKeyExample {
    use std::vector;
    use std::address;

    // Demonstrate module key usage with optional address and module name
    // Aptos Move does not have explicit syntax for module keys in code,
    // but we simulate by functions that work with address and module names

    public fun make_module_key(address: address, module_name: vector<u8>): (address, vector<u8>) {
        (address, module_name)
    }

    public fun module_key_name_length(address: address, module_name: vector<u8>): u64 {
        let len = vector::length<u8>(&module_name) as u64;
        len + (move_to_u64(address) & 0xFF)
    }

    fun move_to_u64(addr: address): u64 {
        let bytes = address::to_bytes(&addr);
        let b0 = *vector::borrow(&bytes, 0) as u64;
        let b1 = *vector::borrow(&bytes, 1) as u64;
        let b2 = *vector::borrow(&bytes, 2) as u64;
        let b3 = *vector::borrow(&bytes, 3) as u64;
        (b0 << 24) + (b1 << 16) + (b2 << 8) + b3
    }
}



//# run 0xCAFE::ModuleKeyExample::make_module_key --args 0xCAFE b"TestModule"



//# run 0xCAFE::ModuleKeyExample::module_key_name_length --args 0xCAFE b"My_Module"





//# publish
module 0xCAFE::LabelReplaceExample {
    // This module demonstrates a simulated transformation that replaces a label
    // For the test, we simulate control flow with a loop and a label-like variable

    public fun loop_with_label_replace(): u64 {
        let counter = 0u64;
        let label_state = 0u8; // 0 means original label, 1 means replaced label

        while (counter < 5) {
            if (counter == 2) {
                label_state = 1;
            };
            if (label_state == 1) {
                counter = counter + 2;
            } else {
                counter = counter + 1;
            };
        };
        counter
    }

    public fun multiple_labels_simulation(): u64 {
        let state = 0u8;
        let i = 0u64;

        loop {
            if (state == 0) {
                i = i + 1;
                if (i == 3) {
                    state = 1;
                };
            } else if (state == 1) {
                i = i + 10;
                break;
            };
        };
        i
    }
}



//# run 0xCAFE::LabelReplaceExample::loop_with_label_replace



//# run 0xCAFE::LabelReplaceExample::multiple_labels_simulation


// Features:
// 2be796a585136f9ffe37111541537241: Mark certain functions or constructs as native to Move using the 'native' keyword indicating they are implemented outside of Move.
// 1d9fa496d61af9b5404ccf32b1548863: Use module keys that include an optional address and a module name.
// e04f4e6393f3cc70f5b7a7eb7c919001: Replace block or label references with a new label during control flow graph transformations
