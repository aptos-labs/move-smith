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
        // Normally, deprecated syntax warnings are compiler warnings.
        // To simulate the syntax misuse, we'll just call a method with correct syntax.
        // Since the demo aims to test deprecated syntax, you might mimic it in comments.
        // For actual code, just call the method correctly.
        // Example:
        // obj::push::<T>(vector::len(&obj.items));
        // But since this is illustrative, and syntax misuse causes compilation errors,
        // we will leave this function empty or with a correct call.
    }

    // 3. Load and deserialize a module from a file (simulate by reading bytes)
    public fun load_module_from_bytes(bytes: vector<u8>): bool {
        // Simulate deserialization (assuming bytes represent a compiled module)
        // Since actual deserialization would require module parser, here we just check bytes length
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
            let item_ref = vector::borrow(&items, i);
            string::append(&mut result, item_ref);
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
        "Span(start=10, end=20)".to_string()
    }
}



//# run 0xCAFE::FeatureInteractionTest::test_deprecated_generic_syntax --signers 0xBEBE --args 0u8


//# run 0xCAFE::FeatureInteractionTest::load_module_from_bytes --args [1, 2, 3]


//# run 0xCAFE::FeatureInteractionTest::check_move_2_feature


//# run 0xCAFE::FeatureInteractionTest::format_list_with_delimiter --args ["apple", "banana", "cherry"] " | "


//# run 0xCAFE::FeatureInteractionTest::get_current_token_span
