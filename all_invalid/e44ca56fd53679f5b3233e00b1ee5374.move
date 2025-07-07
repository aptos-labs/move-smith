// Transactional test for Move compiler and VM covering:
// 1. Assignment to variables using names and nested access chains
// 2. Nested loops with break statements influenced by outer conditional
// 3. Parsing escape sequences in byte string literals

module 0x1::TestTransaction {

    use std::vector;
    use std::string;

    // A struct with nested fields to test nested access chain assignment
    struct NestedStruct has copy, drop, store {
        a: u64,
        b: InnerStruct,
    }

    struct InnerStruct has copy, drop, store {
        x: u64,
        y: u64,
    }

    #[test_only]
    public entry fun run_tests() {
        // ========
        // 1. Assignment to variable/name and nested access chain

        // Direct variable assignment
        let mut simple_var = 10u64;
        assert!(simple_var == 10, 100);

        simple_var = 20;
        assert!(simple_var == 20, 101);

        // Initialize NestedStruct
        let mut nested = NestedStruct { a: 1, b: InnerStruct { x: 100, y: 200 } };

        // Assign to nested field: nested.b.x
        nested.b.x = 999;
        assert!(nested.b.x == 999, 102);

        // Assign to nested field: nested.a
        nested.a = 500;
        assert!(nested.a == 500, 103);


        // ========
        // 2. Nested loops with break and outer conditional

        let mut outer_cond = true;
        let mut loop_count: u64 = 0;
        let mut break_outer_loop = false;

        // Outer loop labelled 'outer:'
        'outer: loop {
            loop_count = loop_count + 1;

            if (outer_cond) {
                // inner loop
                let mut inner_loop_count = 0;
                loop {
                    inner_loop_count = inner_loop_count + 1;
                    // Break condition in inner loop
                    if (inner_loop_count == 5) {
                        break;
                    }
                    // This break should break out of outer loop as well
                    if (inner_loop_count == 3 && loop_count == 2) {
                        break_outer_loop = true;
                        break 'outer;
                    }
                }
            } else {
                break;
            }

            // Safety net: prevent infinite looping in test
            if (loop_count > 10) {
                break;
            }
        }

        // Test that the loops behaved as expected
        // Expected: break_outer_loop true, loop_count == 2
        assert!(break_outer_loop == true, 200);
        assert!(loop_count == 2, 201);


        // ========
        // 3. Escape sequences in byte string literals

        // Define byte string with various escape sequences:
        // \x20 (space), \n (newline), \r (carriage return), \t (tab), \\ (backslash), \" (double quote)

        let bs: vector<u8> = b"Line1\\nLine2\\t\\x20!\\r\\\"End\\\\";

        // Expected bytes:
        // ASCII for: L i n e 1 \ n L i n e 2 \ t ' ' ! \r " E n d \
        // Because each escape sequence is escaped literally (double \), so they become backslash + letter.

        // That is the literal byte string:  4C 69 6E 65 31 5C 6E 4C 69 6E 65 32 5C 74 20 21 5C 72 5C 22 45 6E 64 5C
        // Let's decode to bytes by hand:
        // 'L' = 0x4C
        // 'i' = 0x69
        // 'n' = 0x6E
        // 'e' = 0x65
        // '1' = 0x31
        // '\' = 0x5C
        // 'n' = 0x6E
        // 'L' = 0x4C
        // 'i' = 0x69
        // 'n' = 0x6E
        // 'e' = 0x65
        // '2' = 0x32
        // '\' = 0x5C
        // 't' = 0x74
        // ' ' = 0x20
        // '!' = 0x21
        // '\' = 0x5C
        // 'r' = 0x72
        // '\' = 0x5C
        // '"' = 0x22
        // 'E' = 0x45
        // 'n' = 0x6E
        // 'd' = 0x64
        // '\' = 0x5C

        // Check length
        assert!(vector::length(&bs) == 26, 300);

        // Check some bytes explicitly
        assert!(*vector::borrow(&bs, 5) == 0x5C, 301);    // '\'
        assert!(*vector::borrow(&bs, 6) == 0x6E, 302);    // 'n'
        assert!(*vector::borrow(&bs, 14) == 0x20, 303);   // space
        assert!(*vector::borrow(&bs, 18) == 0x5C, 304);   // '\'
        assert!(*vector::borrow(&bs, 19) == 0x72, 305);   // 'r'
        assert!(*vector::borrow(&bs, 20) == 0x5C, 306);   // '\'
        assert!(*vector::borrow(&bs, 21) == 0x22, 307);   // '"'

    }
}

// Featurres:
// b4d5e5bf6e01587ef90a3968742e1e88: Assign to a variable using a name or a nested access chain.
// 12114af09de99c2526fd934eda77cf45: Test that nested loops correctly handle break statements with an outer conditional.
// 659093aaa06dbbccf038b7a254c7d576: Parse escape sequences in byte string literals.
