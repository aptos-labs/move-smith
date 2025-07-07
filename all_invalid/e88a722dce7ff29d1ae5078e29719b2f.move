
//# publish
module 0xDEAD::TestModule {
    // Define constants for testing
    const CONST_A: u8 = 42;
    const CONST_B: u64 = 1000;

    // Define a generic struct with different type parameters
    struct GenericStruct<T, U> has store, key {
        field_t: T,
        field_u: U
    }

    // Define a struct with type parameter and explicit schema information
    struct SchemaStruct<T> has store, key {
        data: T
    }

    // Define an enum with multiple variants
    enum TestEnum has copy, drop, store {
        Variant1,
        Variant2(u8, u64),
        Variant3 { flag: bool }
    }

    // Function that initializes and returns a struct with generics and control logging
    public fun create_generic_struct<T: store + copy, U: store + copy>(x: T, y: U): GenericStruct<T, U> {
        // Instantiate a generic struct with provided parameters
        let s = GenericStruct {field_t: x, field_u: y};
        s
    }

    // Function demonstrating control of compiler logging output by setting an environment variable
    public fun set_log_output() {
        // Environment variable setting is outside the language, but we simulate the concept
        // For illustration: (In actual test, this should be an environ setting)
        // set_env("MOVE_COMPILER_LOG_LEVEL", "DEBUG");
        // set_env("MOVE_COMPILER_LOG_FILE", "move_compile_debug.log");
        // Actual environment setting is done outside code, no real code needed here
        ()
    }

    // Function that creates a schema struct with a type parameter
    public fun create_schema_struct<T: store + copy>(value: T): SchemaStruct<T> {
        let s = SchemaStruct {data: value};
        s
    }

    // Function with control of multiple features including nested enum usage
    public fun complex_function() {
        let enum_instance = if (true) {
            TestEnum::Variant2(1, 2)
        } else {
            TestEnum::Variant3 { flag: false }
        }; // <-- added semicolon here
        // Use enum instance in some way
        match enum_instance {
            TestEnum::Variant1 => (),
            TestEnum::Variant2(a, b) => {
                let _sum = a + b;
            },
            TestEnum::Variant3 { flag } => {
                if (flag) {}
            }
        }; // <-- added semicolon here
    }

    // Function testing the control of logging verbosity
    public fun test_logging_control() {
        // Assume environment variables are set externally for verbosity and output file
        // e.g., MOVE_COMPILER_LOG_LEVEL=TRACE
        //       MOVE_COMPILER_LOG_FILE=debug_log.txt
        ()
    }
}



//# run 0xDEAD::TestModule::create_generic_struct --args 123u8 456u64


// Features:
// cbf9c66be899e3d28ae69bf46264946a: Define a module with various members including functions, constants, structs, and schema specifications.
// bd1017e17faf5ea5b8da39f82b2b1350: Control logging output of the Move compiler by setting an environment variable to specify logging verbosity and output file.
// fa09991c70ad2489dd408fee816518bc: Use type parameters in the types of struct fields.
