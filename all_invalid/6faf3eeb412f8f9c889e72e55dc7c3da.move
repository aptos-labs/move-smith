
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Native struct declaration for testing purposes
    native struct NativeStruct;
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
        // For native structs, typically their instantiation is within native code,
        // but for completeness, we just call the native struct (no instantiation needed)
        // This is just a test to ensure native structs are declared properly.
        // No runtime action needed.
        NativeStruct;
    }

    public fun run_all_tests(): () {
        let _ = run_break_in_while();
        let _ = test_type_parameter_in_struct();
        let _ = test_native_struct();
    }
}


//# run 0xCAFE::TestModule::run_all_tests


// Featurres:
// 597826eeb04ffbc6701b149cc4c8e094: Test that a break statement inside a while loop correctly exits the loop and updates variables as expected.
// 23d28765e83d1c28a76e0128b07aa18d: Declare type parameters for structs using angle brackets '<' and '>'
// 278bf66aab27186e0dd2501b23f30df9: Declare native structs by marking them as native and ending the declaration with a semicolon.
