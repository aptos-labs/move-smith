module 0xCAFE::TypeInstantiationAndDiagnostics {
    use std::vector;

    // Generic struct with known type parameter
    struct Container<T> has copy, drop, store {
        value: T
    }

    // Function to instantiate Container with concrete type u64
    public fun instantiate_u64(val: u64): Container<u64> {
        Container { value: val }
    }

    // Function to instantiate Container with type parameter at function call site
    public fun instantiate_generic<T>(val: T): Container<T> {
        Container { value: val }
    }

    // Native function declaration (assuming implementation outside Move)
    native public fun external_process(value: u32);

    // Function to call external_process to simulate diagnostic message
    public fun call_external_process() {
        external_process(42);
    }
}


//# run 0xCAFE::TypeInstantiationAndDiagnostics::instantiate_u64 --args 123456u64


//# run 0xCAFE::TypeInstantiationAndDiagnostics::instantiate_generic --args 789 --type-args u8


//# run 0xCAFE::TypeInstantiationAndDiagnostics::call_external_process

// Note:
// The main fix is in the invocation of instantiate_generic. Instead of passing '789u8' as a string argument, pass the value '789' and specify the type argument '--type-args u8'.
// This aligns with Move CLI's requirement: the value should be a plain number, and the type parameter specified separately.