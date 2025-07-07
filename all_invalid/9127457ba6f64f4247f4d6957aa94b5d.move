
//# publish
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


//# run 0xCAFE::TypeInstantiationAndDiagnostics::instantiate_generic --args 789u8


//# run 0xCAFE::TypeInstantiationAndDiagnostics::call_external_process


// Featurres:
// 6349b8faf63656ea45d13e00c3eecb18: Instantiate generic types with concrete types or type parameters.
// 73265337ad08f8e478c741080579f48a: Receive and process diagnostic messages generated during Move code compilation
// 23028a622093b2d13fc6c7bf2bb93f16: Mark functions as native to indicate they are implemented outside Move language.
