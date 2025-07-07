// # publish
module 0xCAFE::EmptyStructs {
    use std::debug;

    // Empty struct with copy and drop abilities
    struct Empty has copy, drop, store { }

    // Empty struct with key (can be stored globally)
    struct EmptyKey has copy, drop, store, key { }

    // A function to create local variables with initialization for debugging
    public fun debug_locals(): vector<u8> {
        let local_empty = Empty {};
        let local_empty_key = EmptyKey {};
        // Format a vector<u8> that describe the state
        // For empty structs we just return fixed byte string,
        // Since they do not have fields
        debug::print(b"local_empty and local_empty_key initialized\n")
    }

    // A function to test the version requirement
    // It will abort if Move version < 5 (example)
    public fun require_min_version() {
        std::version::require_version(5, 0, 0);
    }

    // Runner that calls all functions above
    public fun runner() {
        debug_locals();
        require_min_version();
    }
}
// # run 0xCAFE::EmptyStructs::runner --signers 0xCAFE


// # run
script {
    use std::debug;
    use 0xCAFE::EmptyStructs;

    fun main(account: signer) {
        // Run the module runner function
        EmptyStructs::runner();
        
        // Additional local empty struct usage in script
        let local_in_script = EmptyStructs::Empty {};
        debug::print(b"Script local empty struct created\n");
    }
}

// Featurres:
// a1012bc33bd28958397f5112b643c7cf: Create empty struct variants with no fields.
// d659805a1f3400baaa0fcc16c1262b73: Use the function to format the initialization state of local variables for debugging or reporting purposes.
// 28df48782a29a78c04bbccf99d0e5ae8: Require the Move version to meet a minimum specified version.
