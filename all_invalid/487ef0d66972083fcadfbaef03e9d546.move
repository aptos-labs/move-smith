// File: ByteValidator.move
address 0x1 {
    module ByteValidator {
        use std::error;
        use std::vector;

        /// Valid byte verification criteria:
        /// - bytes must be ASCII printable characters (0x20 to 0x7E)
        /// - or underscore (0x5F)
        /// - For demonstration, let's say permitted bytes are letters, digits, space, underscore.
        public fun is_valid_byte(b: u8): bool {
            (b >= 0x30 && b <= 0x39) ||  // '0' - '9'
            (b >= 0x41 && b <= 0x5A) ||  // 'A' - 'Z'
            (b >= 0x61 && b <= 0x7A) ||  // 'a' - 'z'
            (b == 0x20) /* space */ ||
            (b == 0x5F) /* underscore */
        }

        /// Validate each byte in a vector, abort with error if any invalid byte found.
        public fun validate_bytes(bytes: vector<u8>) acquires Error {
            let len = vector::length(&bytes);
            let mut i = 0;
            while (i < len) {
                let b = *vector::borrow(&bytes, i);
                if (!is_valid_byte(b)) {
                    abort error::invalid_argument(E_INVALID_BYTE);
                }
                i = i + 1;
            }
        }

        const E_INVALID_BYTE: u64 = 0x01;
    }
}


// File: AbilityDefinitions.move
address 0x2 {
    module AbilityDefinitions {
        // Postfix ability declarations terminated by semicolons when present

        // Struct with abilities: copy and drop, semicolon terminated
        struct CopyDropStruct has copy, drop;

        // Struct with ability store only, semicolon terminated explicitly
        struct StoreStruct has store;

        // Struct with multiple abilities must terminate with semicolon
        struct AllAbilities has copy, drop, store;

        // Struct with no abilities (empty)
        struct EmptyStruct;
    }
}


// File: Aggregator.move
address 0x3 {
    module Aggregator {
        use std::string;
        use std::vector;

        /// Aggregate source code contents and comments from multiple sources into one vector<string>
        /// Comments included start with '//'

        /// Concatenate two vectors of strings into one
        public fun concat_sources(sources1: vector<string::String>, sources2: vector<string::String>): vector<string::String> {
            let mut result = vector::empty<string::String>();
            let len1 = vector::length(&sources1);
            let mut i = 0;
            while (i < len1) {
                vector::push_back(&mut result, vector::borrow(&sources1, i).clone());
                i = i + 1;
            }
            let len2 = vector::length(&sources2);
            i = 0;
            while (i < len2) {
                vector::push_back(&mut result, vector::borrow(&sources2, i).clone());
                i = i + 1;
            }
            result
        }

        /// Filter and return only comment lines starting with '//'
        public fun filter_comments(lines: vector<string::String>): vector<string::String> {
            let mut comments = vector::empty<string::String>();
            let len = vector::length(&lines);
            let mut i = 0;
            while (i < len) {
                let line = vector::borrow(&lines, i);
                if (string::starts_with(line, "//")) {
                    vector::push_back(&mut comments, line.clone());
                }
                i = i + 1;
            }
            comments
        }

        /// Example combined aggregation of sources and comments from two vectors
        public fun aggregate_program(
            src1: vector<string::String>,
            src2: vector<string::String>
        ): (vector<string::String>, vector<string::String>) {
            let aggregated = concat_sources(src1, src2);
            let comments = filter_comments(aggregated);
            (aggregated, comments)
        }
    }
}


// File: transactional_test.move
address 0x4 {
    module TransactionalTest {
        use 0x1::ByteValidator;
        use 0x2::AbilityDefinitions;
        use 0x3::Aggregator;
        use std::vector;
        use std::string;
        use std::error;

        #[test] // Aptos test attribute to define a transactional test
        public fun test_all_features() {
            // 1. Semicolon terminated postfix ability declarations
            // Check that the structs compile can be instantiated

            // Instantiate CopyDropStruct (has copy, drop)
            let _cd = AbilityDefinitions::CopyDropStruct {};

            // Instantiate StoreStruct (has store)
            let _s = AbilityDefinitions::StoreStruct {};

            // Instantiate AllAbilities
            let _a = AbilityDefinitions::AllAbilities {};

            // Instantiate EmptyStruct
            let _e = AbilityDefinitions::EmptyStruct {};

            // 2. Validate each character in a byte sequence according to permitted criteria
            let valid_bytes = b"Hello_World_123"; // all allowed chars
            ByteValidator::validate_bytes(vector::from_bytes(valid_bytes));

            // This should fail - include an invalid char '\x19' (non-printable control char)
            let invalid_bytes = b"Invalid\x19Byte";
            let res = error::catch_abort_code(move || {
                ByteValidator::validate_bytes(vector::from_bytes(invalid_bytes));
            });
            assert!(res == ByteValidator::E_INVALID_BYTE, 100);

            // 3. Aggregate source definitions and comments

            // Prepare two example source vectors (simulating contents of move source lines)
            let src1 = vector::empty<string::String>();
            vector::push_back(&mut src1, string::utf8(b"// This is a comment from src1"));
            vector::push_back(&mut src1, string::utf8(b"struct A has copy, drop;"));
            vector::push_back(&mut src1, string::utf8(b"// Another comment"));

            let src2 = vector::empty<string::String>();
            vector::push_back(&mut src2, string::utf8(b"// Comment from src2"));
            vector::push_back(&mut src2, string::utf8(b"struct B has store;"));
            vector::push_back(&mut src2, string::utf8(b""));

            let (aggregated, comments) = Aggregator::aggregate_program(src1, src2);

            // Check aggregated length matches sum
            assert!(vector::length(&aggregated) == 6, 101);

            // Check comments extracted correctly (expecting exactly 3 comments)
            assert!(vector::length(&comments) == 3, 102);

            let expected_comments = vector::empty<string::String>();
            vector::push_back(&mut expected_comments, string::utf8(b"// This is a comment from src1"));
            vector::push_back(&mut expected_comments, string::utf8(b"// Another comment"));
            vector::push_back(&mut expected_comments, string::utf8(b"// Comment from src2"));

            let c_len = vector::length(&comments);
            let mut i = 0;
            while (i < c_len) {
                let expected = vector::borrow(&expected_comments, i);
                let actual = vector::borrow(&comments, i);
                assert!(string::equal(expected, actual), 103 + i);
                i = i + 1;
            }
        }
    }
}

// Featurres:
// 01e536d50522315aa5fd12654ac3bde0: Use a semicolon to terminate postfix ability declarations when present.
// c0b78578eb3e13abcdf56b70cfdfafe4: Validate that each character in a byte sequence is permitted according to specific criteria
// 12c8256ad07a90199b4f857924e03b64: Aggregate source definitions and comments from multiple Move source files into a unified program structure.
