
//# publish
module 0xCAFE::TestModule {
    use std::vector; // This warning can be ignored or removed if not used

    // Native struct declaration for testing purposes
    native struct NativeStruct {
        // No fields required; native structs can be empty.
    }
    // End of native struct declaration

    struct GenericStruct<T> has store, key {
        value: T
    }

    public fun run_break_in_while(): u8 {
        let i = 0u8;
        while (i < 10) {
            if (i == 5) {
                break;
            };
            i = i + 1;
        };
        i
    }

    public fun test_type_parameter_in_struct(): u32 {
        let gs = GenericStruct<u16> { value: 123u16 };
        let val = gs.value;
        val as u32
    }

    public fun test_native_struct(): () {
        // For native structs, instantiation is not needed
        // but to ensure the native struct is linked, we can create a reference
        let _ = &NativeStruct{};
        // Alternatively, if referencing is not preferred, leave empty
    }

    public fun run_all_tests(): () {
        let _ = run_break_in_while();
        let _ = test_type_parameter_in_struct();
        let _ = test_native_struct();
    }
}



//# run 0xCAFE::TestModule::run_all_tests
