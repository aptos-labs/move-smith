
//# publish
module 0xCAFE::TestEdgeSplitting {
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
            0 != 0
        } else {
            1 != 0
        }
    }

    // Function that tries to perform an operation on a struct (privileged)
    // from outside the module should not be possible
    // (Note: this function is public, but it calls a private fun; in Move an internal fun is private)
    // but since `privileged_update` is private, calling inside module is fine.
    // If you need to prevent outside calls, mark `privileged_update` private.
    // This function will be called from outside, so it must be public.
    public fun attempt_privileged_struct_op(data: &mut DataStruct, val: u64) {
        // Call to a private function: only allowed within the module
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