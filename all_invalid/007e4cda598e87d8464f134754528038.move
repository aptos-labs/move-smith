
//# publish
module 0xCAFE::CycleDetection {
    use std::vector;

    // Function to create a cycle for testing
    public fun cycle_fn_a() {
        cycle_fn_b();
    }

    public fun cycle_fn_b() {
        cycle_fn_c();
    }

    public fun cycle_fn_c() {
        cycle_fn_a(); // cycle back to fn_a to create a cycle
    }

    // Function to check for cycle detection - dummy implementation
    // In actual compiler tests, this might be a special annotation or marker.
    public fun check_for_cycles() {
        // This function is a placeholder for a test that checks the compiler's
        // ability to detect cycles in the call graph.
        // No actual implementation needed here for the test.
    }
}



//# run 0xCAFE::CycleDetection::check_for_cycles



//# publish
module 0xCAFE::StringTrim {
    // Function to trim leading whitespace (spaces and tabs)
    public fun trim_leading_whitespace(s: vector<u8>): vector<u8> {
        let len = vector::length(&s);
        let index = 0; // Change to mutable variable
        while (index < len) {
            let byte_ref: &u8 = &vector::borrow(&s, index);
            let b = *byte_ref;
            if (b != 0x20u8 && b != 0x09u8) {
                break;
            };
            index = index + 1;
        };
        vector::slice(&s, index, len - index)
    }
}



//# run 0xCAFE::StringTrim::trim_leading_whitespace --args "b\"   \tSomeText\""