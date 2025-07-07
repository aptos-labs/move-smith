// Tests.move
address 0x1 {
    module TestCompilerDiagnostics {
        use std::error;
        use std::vector;
        use std::string;

        /// A struct to represent a diagnostic message
        struct Diagnostic has copy, drop, store {
            message: vector<u8>,
            position: u64,
        }

        /// Helper function to create a diagnostic
        public fun new_diagnostic(message: &vector<u8>, position: u64): Diagnostic {
            Diagnostic {
                message: vector::clone(message),
                position,
            }
        }

        /// Comparator to sort diagnostics by position then lex order of messages
        public fun compare_diag(a: &Diagnostic, b: &Diagnostic): bool {
            if (a.position < b.position) {
                true
            } else if (a.position > b.position) {
                false
            } else {
                vector::lt_bytes(&a.message, &b.message)
            }
        }

        /// Unique diagnostics insertion helper
        public fun insert_unique(diagnostics: &mut vector<Diagnostic>, diag: Diagnostic) {
            let len = vector::length(diagnostics);
            let mut found = false;
            let mut i = 0;
            while (i < len && !found) {
                let existing = &vector::borrow(diagnostics, i);
                if (existing.position == diag.position && vector::equals(&existing.message, &diag.message)) {
                    found = true;
                };
                i = i + 1;
            };
            if (!found) {
                vector::push_back(diagnostics, diag);
            }
        }

        /// Simulate parsing a list: accepts input vector and returns diagnostics
        public fun parse_list_elements(tokens: vector<vector<u8>>): vector<Diagnostic> {
            let mut diagnostics = vector::empty<Diagnostic>();
            let mut idx = 0;
            let len = vector::length(&tokens);

            while (idx < len) {
                let token = &vector::borrow(&tokens, idx);
                // Here we simulate that valid tokens are numeric strings "0".."9"
                if (!string::all_ascii(token)) {
                    let msg = b"Invalid token: non-ASCII detected";
                    let diag = new_diagnostic(&vector::from_bytes(msg), idx as u64);
                    insert_unique(&mut diagnostics, diag);
                } else if (!vector::contains_all(token, b"0123456789")) {
                    // If token contains any char outside 0..9 => error
                    let msg = b"Unexpected token: token must be digits only";
                    let diag = new_diagnostic(&vector::from_bytes(msg), idx as u64);
                    insert_unique(&mut diagnostics, diag);
                }
                idx = idx + 1;
            };

            // Sort diagnostics by position then message
            sort_diagnostics(&mut diagnostics);

            diagnostics
        }

        /// Insertion sort to sort diagnostics vector based on compare_diag
        public fun sort_diagnostics(diagnostics: &mut vector<Diagnostic>) {
            let len = vector::length(diagnostics);
            let mut i = 1;
            while (i < len) {
                let mut j = i;
                while (j > 0) {
                    let a = vector::borrow(diagnostics, j - 1);
                    let b = vector::borrow(diagnostics, j);
                    if (!compare_diag(b, a)) {
                        break;
                    };
                    // swap diagnostics[j], diagnostics[j-1]
                    let temp = vector::borrow(diagnostics, j);
                    let temp_copy = *temp;
                    *vector::borrow_mut(diagnostics, j) = *vector::borrow(diagnostics, j - 1);
                    *vector::borrow_mut(diagnostics, j - 1) = temp_copy;
                    j = j - 1;
                }
                i = i + 1;
            }
        }

        /// Define a module given id and definition string (dummy)
        public fun module(module_id: vector<u8>, definition: vector<u8>): vector<u8> {
            // Just return a concatenated bytes vector of "module:", id, ";def:", definition for simulation
            let prefix = vector::from_bytes(b"module:");
            let mid = vector::from_bytes(b";def:");
            let mut result = vector::empty<u8>();
            vector::append(&mut result, &prefix);
            vector::append(&mut result, &module_id);
            vector::append(&mut result, &mid);
            vector::append(&mut result, &definition);
            result
        }

        #[test_only]
        public fun test_transaction_case() {
            // Prepare tokens with some unexpected ones (non-digits, non-ASCII)
            let tokens = vector::empty<vector<u8>>();
            vector::push_back(&mut tokens, vector::from_bytes(b"123"));
            vector::push_back(&mut tokens, vector::from_bytes(b"abc")); // unexpected tokens (non-digits)
            vector::push_back(&mut tokens, vector::from_bytes(b"45"));
            vector::push_back(&mut tokens, vector::from_bytes(b"\xFF")); // non-ASCII invalid token
            vector::push_back(&mut tokens, vector::from_bytes(b"789"));

            // Parse and get diagnostics
            let diags = parse_list_elements(tokens);

            // Check results are sorted and unique (message and position)
            let len = vector::length(&diags);
            assert!(len == 2, 100);

            let d1 = vector::borrow(&diags, 0);
            let d2 = vector::borrow(&diags, 1);

            // Check that diagnostics have correct messages and positions
            // d1 should be for token index 1 with "Unexpected token" error
            assert!(d1.position == 1, 101);
            assert!(vector::equals(&d1.message, &vector::from_bytes(b"Unexpected token: token must be digits only")), 102);

            // d2 should be for token index 3 with "Invalid token" error
            assert!(d2.position == 3, 103);
            assert!(vector::equals(&d2.message, &vector::from_bytes(b"Invalid token: non-ASCII detected")), 104);

            // Test 'module' function defines a module id + definition string
            let id = vector::from_bytes(b"MyMod");
            let def = vector::from_bytes(b"// test module");
            let val = module(id, def);

            let expected = vector::from_bytes(b"module:MyMod;def:// test module");
            assert!(vector::equals(&val, &expected), 105);
        }
    }
}

// Featurres:
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
// d5ae5ffa6b3cb49ad37b0b0edab9aa3c: Render sorted and unique diagnostics for display to assist developers in identifying issues.
// b5a32a6117cd6d94dbd90966e801970e: Define modules using the 'module' function with a module identifier and its definition.
