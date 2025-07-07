//# publish
module 0xCAFE::Token {
    // Define a resource with the copy ability to test Copy trait
    struct CopyToken has copy, drop {
        id: u64,
        name: vector<u8>,
    }

    public fun create_copy_token(id: u64, name: vector<u8>): CopyToken {
        CopyToken { id, name }
    }
}

//# publish
module 0xCAFE::ModuleContained {
    use 0xCAFE::Token;

    // Function returning a function type as a parameter
    public fun apply_func_and_return(f: fn() -> u64): u64 {
        f()
    }

    // A simple function to be passed as argument
    public fun provided_func(): u64 {
        42
    }

    // Function to retrieve module's identifier (address and name)
    public fun get_module_id(): (address, vector<u8>) {
        (get_address(), get_name())
    }

    // Helper function to extract module's address
    public fun get_address(): address {
        // Use built-in trait or known fixed address for test
        0xCAFE
    }

    // Helper function to get module's name
    public fun get_name(): vector<u8> {
        b"ModuleContained"
    }
}

//# run 0xCAFE::Token::create_copy_token --args 1u64 b"TokenName"
//# run 0xCAFE::ModuleContained::apply_func_and_return --signers 0xCAFE --args 0xCAFE::ModuleContained::provided_func
//# run 0xCAFE::ModuleContained::get_module_id --signers 0xCAFE