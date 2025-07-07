
//# publish
module 0xCAFE::InlineFunctionRemoval {
    use std::vector;

    // Inline function to be tested for removal after inlining
    public inline fun inline_identity<T: copy>(value: T): T {
        value
    }

    public fun test_inline_removal(value: u8): u8 {
        // Call the inline function
        inline_identity(value)
    }
}


//# publish
module 0xCAFE::MapFunctionTest {
    use std::option;

    // Function to map over an option value applying a function
    public fun map_option<T: copy, U: copy>(opt: option::Option<T>, func: |T|: U): option::Option<U> {
        if (option::is_some(&opt)) {
            let val = option::borrow(&opt);
            option::some(func(*val))
        } else {
            option::none()
        }
    }
}


//# publish
module 0xCAFE::PragmaTest {
    // Pragmas (these are just comments, but for the purpose of the test, we're simulating annotations)
    // pragmas: [{id: PRAGMA_INLINE, value: 0}, {id: PRAGMA_OPTIMIZE, value: "speed"}]
    public fun annotated_function(): u64 {
        42u64
    }

    // pragmas: [{id: PRAGMA_DISABLE, value: "global_analysis"}]
    public fun disabled_analysis(): u64 {
        7u64
    }
}


//# run 0xCAFE::InlineFunctionRemoval::test_inline_removal --args 42u8


//# run 0xCAFE::MapFunctionTest::map_option --args Some(10u64) --args |x| -> u64 {x + 1}


//# run 0xCAFE::PragmaTest::annotated_function


//# run 0xCAFE::PragmaTest::disabled_analysis


// Featurres:
// 4957c6b77b94890bc1f8b09f0feac0e4: Remove inline functions from the program after inlining to reduce code size and prevent codegen issues.
// 2546adaf47f70b2598c1cbdc28df4fc3: Test that the map function correctly transforms a some option value by applying a given function.
// 5ece0c0202306687ce2bd784f3e48f8b: Annotate Move code with pragmas whose values can be either literals or identifiers.
