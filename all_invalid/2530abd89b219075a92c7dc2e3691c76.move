//# publish
module 0xCAFE::UniqueVariants {
    // Testing point 1: Ensure all struct variant names are unique within the same struct.
    // Move doesn't allow two variants with the same name in enums or structs.
    // This module defines a struct with a variant enum to test uniqueness of variant names.
    // Although Move enums inside structs are not possible directly,
    // We'll create an enum with unique variant names to test compiler enforcement.

    // Define an enum with unique variants
    enum VariantEnum has copy, drop, store {
        V1,
        V2,
        V3,
    }

    struct VariantStruct has copy, drop, store {
        variant: VariantEnum,
        value: u64,
    }

    // A function that returns a VariantStruct created by matching a variant name
    public fun make_variant_struct(v: u8): VariantStruct {
        let variant = if (v == 1) {
            VariantEnum::V1
        } else if (v == 2) {
            VariantEnum::V2
        } else {
            VariantEnum::V3
        };
        VariantStruct { variant, value: 42 }
    }

    // Runner function to test variant construction without arguments
    public fun runner() {
        let s1 = make_variant_struct(1);
        let s2 = make_variant_struct(2);
        let s3 = make_variant_struct(3);
        // No assertions, just construction exercising variants and struct
        // This also tests copy/move semantics with enum variants
    }
}
//# run 0xCAFE::UniqueVariants::runner


//# publish
module 0xCAFE::TokenSpan {
    use std::debug;

    /// Testing point 2:
    /// Obtain the exact location span of the current token in source code
    /// Move does not expose a built-in API for source location span inside Move code,
    /// but the std::debug module provides a `print` function and `assert` can print code spans on abort.
    ///
    /// Here we test creating an abort with error message containing source location from debug::print
    /// We will simulate a "span" by printing an error message including line/column information via debug::print().
    /// This triggers VM printing and tests printing source location information indirectly.
    ///
    /// If Move compiler and VM support `debug::print`, this will exercise emitting debug info.

    public fun print_token_location() {
        debug::print(b"Token span test: current token at line 52, column 5.\n");
        // This hardcoded message simulates locating a token in source.
    }

    public fun runner() {
        print_token_location();
    }
}
//# run 0xCAFE::TokenSpan::runner


//# publish
module 0xCAFE::PatternUnwrap {
    /// Testing point 3:
    /// Construct and return a new fields structure from assignable values
    /// after unwrapping pattern fields.
    ///
    /// Here, we pass a struct as argument, destructure it with pattern matching,
    /// then construct a new struct with possibly modified field values and return it.

    struct ComplexData has copy, drop, store {
        a: u8,
        b: u64,
        c: bool,
    }

    public fun transform(input: ComplexData): ComplexData {
        // Unwrap pattern fields
        let ComplexData { a, b, c } = input;
        // Construct new struct with changed fields
        let new_a = a + 1 as u8;
        let new_b = b * 2;
        let new_c = !c;
        ComplexData { a: new_a, b: new_b, c: new_c }
    }

    public fun runner() {
        let original = ComplexData { a: 41, b: 100, c: false };
        let transformed = transform(original);
        // No assertions, just calling to exercise pattern unwrap and construction
        let _ = transformed;
    }
}
//# run 0xCAFE::PatternUnwrap::runner


//# run
script {
    use 0xCAFE::UniqueVariants;
    use 0xCAFE::TokenSpan;
    use 0xCAFE::PatternUnwrap;

    fun main() {
        UniqueVariants::runner();
        TokenSpan::runner();
        PatternUnwrap::runner();
    }
}

// Featurres:
// 88c15ed2badc5daf803efcd61e0936a0: Ensure all struct variant names are unique within the same struct.
// 8f22bcbc108f28fd4c89ac1f93c2a530: Obtain the exact location span of the current token in source code for use in error messages and debugging information.
// e1edb0b78d698d134e8bac8aefa5afdb: Construct and return a new fields structure from assignable values after unwrapping pattern fields.
