//# publish
module 0xCAFE::FileFormatAndTypes {
    // Testing file format bytecode and static reference to built-in type names
    use std::vector;
    use std::string;

    const BUILTIN_TYPE_NAMES: vector<vector<u8>> = vector[
        b"bool",
        b"u8",
        b"u64",
        b"u128",
        b"address",
        b"signer",
        b"struct",
        b"vector"
    ];

    public fun get_builtin_type_names_ref(): &vector<vector<u8>> {
        &BUILTIN_TYPE_NAMES
    }

    // Function that returns a lambda from a function parameter
    public fun return_function_type(): (|u8, u8| u8) {
        let add: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        add
    }

    // Test function that uses the lambda function returned
    public fun test_returned_lambda(): u8 {
        let func = return_function_type();
        func(10u8, 20u8)
    }
}

//# run 0xCAFE::FileFormatAndTypes::get_builtin_type_names_ref

//# run 0xCAFE::FileFormatAndTypes::return_function_type

//# run 0xCAFE::FileFormatAndTypes::test_returned_lambda

// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// 8a179fa2700dc8ec1d5a56648cc1defd: Retrieve the 'BUILTIN_TYPE_NAMES' set as a static reference, enabling efficient lookups of built-in type names within Move code.
// 1acc13f6fd8a2090e6e29b86b2deaa8a: Return function types as the result of a function parameter.
