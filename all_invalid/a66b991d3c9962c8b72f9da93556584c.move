
//# publish
module 0xCAFE:TestEdgeSplitting {
    // Dummy struct for testing struct operations
    struct DataStruct {
        field1: u64,
        field2: bool,
    }

    // Privileged operation: only accessible within this module
    fun privileged_update(data: &mut DataStruct, new_field1: u64) {
        data.field1 = new_field1;
    }

    // Function that performs control flow with critical edge splitting
    public fun control_flow_split(input: bool): bool {
        if (input) {
            // Critical edge: no intervening abort point, tests edge splitting
            0
        } else {
            1
        }
    }

    // Function that tries to perform an operation on a struct (privileged)
    // from outside the module should not be possible
    public fun attempt_privileged_struct_op(data: &mut DataStruct, val: u64) {
        // Attempt to call privileged update; should only be possible within module
        // But here calling directly, should be okay since it's within the same module
        privileged_update(data, val);
    }

    // Function to trigger an abort with custom abort code
    #[aborts_with_code(42)]
    public fun abort_with_custom_code() {
        abort 42;
    }

    // Function that will be invoked to display abort state (simulate formatting)
    // Using custom abort state annotation
    #[aborts_with_code(99)]
    public fun format_abort() {
        abort 99;
    }
}


//# run 0xCAFE::TestEdgeSplitting::control_flow_split

//# run 0xCAFE::TestEdgeSplitting::abort_with_custom_code

//# run 0xCAFE::TestEdgeSplitting::format_abort

// Featurres:
// 3d5cb9ee90011cf788bdec4f515741a7: Use critical edge splitting to simplify control flow for optimization passes.
// da167b1970ccb5deda57add2fd12ed02: Ensure privileged operations on structs cannot be performed across module boundaries.
// 6f89c2ca9e1261b1efb2c7251ef3af4f: Use custom abort state annotations to format and display the abort state of functions at desired points in Move code
