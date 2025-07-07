
//# publish
module 0xAAAA::PathUtilities {
    use std::vector;
    use std::string;

    // Function to convert a vector of strings to a vector of symbols
    public fun string_vec_to_symbol_vec(strings: vector<string::String>): vector<string::String> {
        // For testing, assume symbol is just a clone of string
        vector::clone(&strings)
    }
}


//# publish
module 0xBBBB::PackagePaths {
    use std::vector;
    use 0xAAAA::PathUtilities;

    // Define a struct with path fields
    struct PackagePaths has copy, drop, store {
        paths: vector<string::String>,
        symbol_paths: vector<string::String>,
    }

    // Function that transforms 'paths' from String to Symbol using the utility function
    public fun transform_paths(pkg_paths: &mut PackagePaths) {
        let symbol_vec = PathUtilities::string_vec_to_symbol_vec(vector::clone(&pkg_paths.paths));
        pkg_paths.symbol_paths = symbol_vec;
    }
}


//# publish
module 0xCCCC::DefaultModule {
    use std::vector;

    // Dummy function
    public fun default_behavior() {
        let v: vector<u8> = vector::empty();
        let _ = v;
    }
}

// Usage example (simulate test run):
// --args should be specified as a list of values, each wrapped in vector[b"..."]
// Correct command for the 'transform_paths' might be:


//# run 0xBBBB::PackagePaths::transform_paths --signers 0xDEAD --args (vector[b"path1", b"path2"])
