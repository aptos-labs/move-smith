// # publish
address 0xCAFE {
    module ConditionalMatch {
        use std::option;

        /// Return an optional u8 based on input conditions using match with guards
        public fun match_with_guard(value: u8, flag: bool): option::Option<u8> {
            match value {
                0 if flag => option::some(100),
                1 if !flag => option::some(200),
                // guard that allows any other even number
                v if (v % 2 == 0) => option::some(v + 1),
                // fallback case returns none
                _ => option::none(),
            }
        }

        /// A function that optionally annotates local variable types
        public fun optional_type_annotation(v: u8): u8 {
            let some_value: option::Option<u8> = match_with_guard(v, true);
            let result = if (option::is_some(&some_value)) {
                // omit type annotation here
                let val = option::borrow(&some_value).unwrap();
                *val + 1
            } else {
                0
            };
            result
        }

        /// Return a byte string literal
        public fun byte_string_literal(): vector<u8> {
            // byte string: hex for "Hello\x00Byte"
            let bytes = b"Hello\x00Byte";
            vector::from_slice(bytes)
        }

        /// A runner function calling all features above and returning true if works
        public fun runner(): bool {
            let cond1 = option::is_some(&match_with_guard(0, true));
            let cond2 = optional_type_annotation(0) == 101;
            let bytes = byte_string_literal();
            let cond3 = vector::length(&bytes) == 10;
            cond1 && cond2 && cond3
        }
    }
}
// # run 0xCAFE::ConditionalMatch::runner

// # run
script {
    use 0xCAFE::ConditionalMatch;

    fun main() {
        // Call match_with_guard directly with various inputs
        let r1 = ConditionalMatch::match_with_guard(0, true);
        let r2 = ConditionalMatch::match_with_guard(1, false);
        let r3 = ConditionalMatch::match_with_guard(2, false);
        let r4 = ConditionalMatch::match_with_guard(3, true);

        // Call optional_type_annotation
        let r5 = ConditionalMatch::optional_type_annotation(0);
        let r6 = ConditionalMatch::optional_type_annotation(1);

        // Call byte_string_literal and check length
        let bytes = ConditionalMatch::byte_string_literal();

        // Call runner and ignore result
        let _ = ConditionalMatch::runner();
    }
}

// Featurres:
// e046b2e91b3910c3dd96eb1be778c6ca: Use 'if' guard conditions in match arms to add conditional logic to pattern matching.
// 7f0eee0ccf6d537626d8da45a5b5f98a: Use optional type annotations in your code to allow types to be present or omitted
// 5f2a00cdcd250456968fb75d1c359440: Use byte string literals to include raw byte sequences within your code.
