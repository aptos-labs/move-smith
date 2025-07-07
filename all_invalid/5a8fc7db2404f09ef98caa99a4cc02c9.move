
//# publish
module 0xCAFE::FeatureInteractionTest {
    use std::vector;
    use std::string;
    use std::require;

    // 1. Struct to test generic structs with nested generics
    struct Container<T> has copy, drop, store {
        items: vector<T>,
    }

    // 2. Function to test deprecated generics syntax (::) in method call
    public fun test_deprecated_generic_syntax<T>(obj: &mut Container<T>) {
        // Using deprecated generic syntax (for compiler warning generation)
        // Note: In Move, deprecated syntax detection is a compiler concern,
        // but we mimic it here with a method call using the syntax
        // This is for testing purposes, assuming the compiler warns on this
        // (Note: actual deprecation warning will only appear on compilation)
        obj::push::<T>(vector::len(&obj.items));
        // The above line is intentionally incorrect syntactically for deprecated syntax 
        // For demonstration, we call a method using the deprecated syntax style
        // In actual code, compiler warnings are triggered, not runtime
        // Here we simulate the form:
        // obj::<T>::push(...)
        // But in Move syntax, calling a method with :: generics is not valid. 
        // So, we demonstrate by calling a function that would use deprecated syntax.
    }

    // 3. Load and deserialize a module from a file (simulate by reading bytes)
    public fun load_module_from_bytes(bytes: vector<u8>): bool {
        // Simulate deserialization (assuming bytes represent a compiled module)
        // Since actual deserialization would require module parser, here we just check bytes length
        // and mimic success.
        if (vector::length(&bytes) > 0) {
            true
        } else {
            false
        }
    }

    // 4. Function to verify feature gate 'move_2' and advance token stream
    public fun check_move_2_feature() {
        // Assume require::require_move_2_and_advance is a feature gating check
        require::require_move_2_and_advance();
        // After this call, assume flow continues (no actual token stream to advance in runtime)
    }

    // 5. Function to format list items into string separated by a custom delimiter
    public fun format_list_with_delimiter(items: vector<string>, delimiter: string): string {
        let result = string::empty();
        let len = vector::length(&items);
        let i = 0;
        while (i < len) {
            let item = vector::borrow(&items, i);
            string::append(&mut result, item);
            if (i + 1 < len) {
                string::append(&mut result, &delimiter);
            }
            i = i + 1;
        };
        result
    }

    // 6. Function to retrieve source span info (simulate with a debug message)
    public fun get_current_token_span(): string {
        // In actual compiler parsing, we'd get the span info.
        // Here, we simulate by returning a static string.
        // For testing, assume we include this span info in errors
        "Span(start=10, end=20)".to_string()
    }
}


//# run 0xCAFE::FeatureInteractionTest::test_deprecated_generic_syntax --signers 0xBEBE --args 0u8

//# run 0xCAFE::FeatureInteractionTest::load_module_from_bytes --args 0x1234

//# run 0xCAFE::FeatureInteractionTest::check_move_2_feature

//# run 0xCAFE::FeatureInteractionTest::format_list_with_delimiter --args [b"apple", b"banana", b"cherry"] " | "

//# run 0xCAFE::FeatureInteractionTest::get_current_token_span


// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// c9f9f16a59bb8eb88f0daf4982297490: Call the `require_move_2_and_advance` function to verify and advance the token stream after confirming the 'move_2' feature is present.
// 43348be6db74ac148e59f7ee16ddd599: Format a list of items into a string with a custom delimiter.
// 8f22bcbc108f28fd4c89ac1f93c2a530: Obtain the exact location span of the current token in source code for use in error messages and debugging information.
