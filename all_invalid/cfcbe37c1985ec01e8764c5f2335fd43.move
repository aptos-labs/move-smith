// PackagePaths module: defines a struct with a vector of String, 
// provides function to convert that vector to Symbols

//# publish
module 0xCAFE::PackagePaths {
    use std::string;
    use std::symbol;

    /// A struct that holds a vector of String, representing paths.
    struct PackagePaths has copy, drop, store {
        paths: vector<string::String>,
    }

    /// A struct that wraps a vector of Symbols (for after transformation)
    struct SymbolPaths has copy, drop, store {
        symbols: vector<symbol::Symbol>,
    }

    /// Function to transform the 'paths' vector from String to Symbol.
    public fun string_vec_to_symbol_vec(paths: &vector<string::String>): vector<symbol::Symbol> {
        let mut out = vector::empty<symbol::Symbol>();
        let len = vector::length(paths);
        let mut i = 0;
        while (i < len) {
            let s = vector::borrow(paths, i);
            let sym = symbol::symbol(s);
            vector::push_back(&mut out, sym);
            i = i + 1;
        };
        out
    }

    /// Function to create an example PackagePaths.
    public fun create_example_package_paths(): PackagePaths {
        let v = vector::empty<string::String>();
        vector::push_back(&mut v, string::utf8(b"/foo/bar"));
        vector::push_back(&mut v, string::utf8(b"/baz/qux"));
        PackagePaths { paths: v }
    }

    /// Runner function to create and transform a paths vector into a symbol vector,
    /// storing the symbol vector in SymbolPaths
    public fun runner() {
        let pkg = Self::create_example_package_paths();
        let syms = string_vec_to_symbol_vec(&pkg.paths);
        let _ = SymbolPaths { symbols: syms };
    }
}

// Run the runner function in PackagePaths to test the transformation.
//# run 0xCAFE::PackagePaths::runner

//------------------------------------------------------
// Negative test: Demonstrate vector operation error with #[expected_failure(vector_error)]
// Attempt to pop from an empty vector.

//# publish
module 0xCAFE::VectorErrorTest {
    use std::vector;

    /// Attempts to pop from empty vector. Should fail with vector_error.
    #[expected_failure(vector_error)]
    public fun runner() {
        let v = vector::empty<u8>();
        let _ = vector::pop_back(&mut v); // This should fail.
    }
}

//# run 0xCAFE::VectorErrorTest::runner

//------------------------------------------------------
// Test a function with type constraint requiring +copy

//# publish
module 0xCAFE::TypeConstraintTest {
    use std::vector;

    public fun runner<T: copy>(x: T) {
        let mut v = vector::empty<T>();
        vector::push_back(&mut v, x);
        // Pop and discard.
        let _ = vector::pop_back(&mut v);
    }
}

// Run with u64 which is +copy
//# run 0xCAFE::TypeConstraintTest::runner --args 123u64

//------------------------------------------------------
// Test a script using the full test script flow

//# run
script {
    use 0xCAFE::PackagePaths;

    fun main() {
        PackagePaths::runner();
    }
}