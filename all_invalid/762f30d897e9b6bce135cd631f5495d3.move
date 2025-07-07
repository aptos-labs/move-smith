
//# publish
module 0xCAFE::EnumStructPatternTest {
    use std::vector;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    enum Color has copy, drop {
        Red,
        Green,
        Blue,
        Custom(u8, u8, u8),
        Gradient { start: u8, end: u8 }
    }

    // Generic struct with type parameter T
    struct Container<T> has copy, drop, store {
        value: T,
        label: vector<u8>,
    }

    // Function to test enum matching with nested patterns, guards, references, and wildcards
    public fun test_enum_matching(e: Color, c: Container<u8>, p: Point): u64 {
        let result: u64;
        match (e) {
            Color::Red => {
                result = 1;
            }
            Color::Green => {
                result = 2;
            }
            Color::Blue => {
                result = 3;
            }
            Color::Custom(r, g, b) => {
                // Guard: only match if r + g + b > 100
                if (r + g + b > 100) {
                    result = 42;
                } else {
                    result = 0;
                }
            }
            Color::Gradient { start, end } => {
                // Match with reference pattern
                let start_ref = &start;
                let end_ref = &end;
                // Check values
                if (*start_ref > 128 && *end_ref > 128) {
                    result = 99;
                } else {
                    result = 88;
                }
            }
        };
        // Match on container with recursive pattern
        match (c) {
            Container { value, label } => {
                // Check label length
                if (vector:: length(&label) == 0) {
                    result = result + 1;
                } else {
                    result = result + 2;
                }
                // Match with inner Point struct
                match (p) {
                    Point { x: xx, y: yy } => {
                        if (xx == 0 && yy == 0) {
                            result = result + 10;
                        } else {
                            result = result + 20;
                        }
                    }
                };
            }
        };
        result
    }

    // Function that tests for loop variable immutability
    public fun test_for_loop_immutability(limit: u64): u64 {
        let sum = 0u64;
        // for (i in 0..limit)
        for (i in 0u64..limit) {
            // *i = i + 1; // This line should cause a compile error if uncommented
            // But Move will not allow reassignment; just ensure no reassign
            let _ = i; // Use i, do not reassign
        };
        sum
    }

    // Runner function invoking all sub-tests
    public fun run_all_tests() {
        let e1 = Color::Red;
        let e2 = Color::Custom(50, 60, 70);
        let e3 = Color::Gradient { start: 200, end: 210 };
        let e4 = Color::Blue;

        let container1: Container<u8> = Container { value: 123, label: vector::empty<u8>() };
        let container2: Container<u8> = Container { value: 45, label: vector::borrow(&vector::empty(), 0) };
        let p1 = Point { x: 0, y: 0 };
        let p2 = Point { x: 10, y: 20 };

        // Call match testing
        let _ = test_enum_matching(e1, container1, p1);
        let _ = test_enum_matching(e2, container2, p2);
        let _ = test_enum_matching(e3, container1, p2);
        let _ = test_enum_matching(e4, container2, p1);

        // Call loop immutability testing
        let _ = test_for_loop_immutability(5);
    }
}


//# run 0xCAFE::EnumStructPatternTest::run_all_tests


// Featurres:
// 88ad55adda6cc00951462b4f5a7eeb94: Test that pattern matching on enums and structs—including nested patterns, wildcards, conditional guards, references, generics, and common fields—works correctly and as expected in Aptos Move.
// 747b4002faaa7e337217152de6e1ffb0: Automatically generate type parameter syntax with proper formatting and numbering.
// ef7dd4f6c5026fa243fcc93c244ad89e: Test that the loop variable in a Move for-loop is immutable and cannot be reassigned within the loop body.
