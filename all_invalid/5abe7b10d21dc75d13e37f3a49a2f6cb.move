//# publish
module 0xCAFE::AliasNameValidation {
    use std::signer;

    // Allowed names: snake_case, CamelCase for structs, SCREAMING_SNAKE_CASE for constants

    // Struct with CamelCase name
    struct ValidStructName has copy, drop, store {
        value: u64,
    }

    // Spec variable: global and local inside spec blocks
    spec spec_var_module: bool;

    // Parameterized spec_variable with initialization in spec block
    spec spec_var_param_module<T>: T;

    // Constant with SCREAMING_SNAKE_CASE
    const MAX_LIMIT: u64 = 1000;

    // Function with snake_case
    public fun valid_function_name(s: &signer) {
        let _v = ValidStructName { value: 42 };
    }

    // "Runner" function for testing
    public fun runner(_s: &signer) {
        // No-op for runner
    }

    spec {
        // Local spec variable inside spec block
        let local_spec_var: u8;
        local_spec_var = 10;
        // Initialize global spec var
        spec_var_module = true;
        spec_var_param_module<u64> = 123;
    }
}


//# run 0xCAFE::AliasNameValidation::runner --signers 0xCAFE

//# publish
module 0xCAFE::MemberNamingConventions {
    use std::signer;

    // Struct with valid CamelCase name
    struct MyStruct has copy, drop, store {
        // Fields: snake_case
        field_one: u64,
        fieldTwo: bool, // Intentionally non snake_case to test compiler acceptance
    }

    // Spec variable with initialization
    spec spec_var_global: u64;

    const DEFAULT_COUNT: u8 = 50;

    // Function with snake_case and PascalCase mixed to test compiler acceptance
    public fun do_something(s: &signer) {
        let instance = MyStruct {
            field_one: 10,
            fieldTwo: true,
        };
        let _x = instance.field_one + DEFAULT_COUNT as u64;
    }

    // Runner without arguments
    public fun runner(_s: &signer) {
        do_something(_s);
    }

    spec {
        spec_var_global = 999;
    }
}


//# run 0xCAFE::MemberNamingConventions::runner --signers 0xCAFE

//# publish
module 0xCAFE::SpecVariablesTesting {
    use std::signer;

    // Spec global variable parameterized with initialization
    spec spec_global_param<T>: T;

    // Spec variable with a complex initialization
    spec spec_var_initialized: bool;

    // Struct to help test spec variable parameterization
    struct Dummy has copy, drop, store {
        id: u64,
    }

    // Function where local spec variables are declared and used
    public fun test_spec_vars(_s: &signer) {
        // no-op
    }

    // Runner function, no argument
    public fun runner(_s: &signer) {
        test_spec_vars(_s);
    }

    spec {
        let local_spec_var1: bool = false;
        let local_spec_var2: u64;
        local_spec_var2 = 12345;
        spec_var_initialized = true;
        spec_global_param<u64> = 0;
        spec_global_param<Dummy> = Dummy { id: 1 };
    }
}


//# run 0xCAFE::SpecVariablesTesting::runner --signers 0xCAFE


//# run 0xCAFE::MemberNamingConventions::do_something --signers 0xCAFE

// Featurres:
// 15bf487ffac07bc955b6ba19d2f96cd5: Validate module member alias names to ensure they meet naming standards before usage.
// edf5d2f4ab13be32218327e2a68ddf57: Name module members (such as functions, structs, or constants) according to allowed naming conventions
// 62b0f2214545ea1a8bf15b06c575942a: Declare specification variables, both local and global, within spec blocks, optionally parameterized and initialized.
