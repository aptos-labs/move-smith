// This transactional test exercises:
// 1) Unary and binary operators including inside spec blocks (specification)
// 2) Match expressions using `match` syntax
// 3) Control flow with labels and blocks to test label replacements coverage

// Address is 0xCAFE as required

// -----------------------------------------
//# publish
module 0xCAFE::OperatorMatch {

    use std::signer;

    // A simple struct to hold u8 values, copy and drop abilities
    struct Data has copy, drop, store, key {
        v: u8,
    }

    // Returns the sum of two u8 numbers, using binary +
    public fun add(a: u8, b: u8): u8 {
        a + b
    }

    // Unary negate is not on integers, but logical not on bools
    public fun neg_bool(val: bool): bool {
        !val
    }

    // Applies specification-only unary plus (specification-only, no runtime)
    spec fun spec_unary_plus(i: u8): u8 {
        +i
    }

    // specification-only binary operators check correctness
    spec fun spec_binary_ops(x: u8, y: u8) {
        assert!(x + y == y + x, 1);
        assert!((x & y) <= x, 2);
    }

    // Demonstrate match expression on a u8 using guards
    public fun match_on_u8(x: u8): u8 {
        match (x) {
            0 => 100,
            1 => 200,
            _ => 255,
        }
    }

    // Match with tuple matching
    public fun match_tuple(a: u8, b: u8): u8 {
        match ((a, b)) {
            (0, 0) => 0,
            (0, _) => 1,
            (_, 0) => 2,
            _ => 3,
        }
    }

    // Test label usage and control-flow with nested loops and breaks (to assist label replacement testing)
    public fun control_flow_labels(x: u8): u8 {
        let mut sum = 0;

        'outer: loop {
            let mut inner_count = 0;
            loop {
                sum = sum + 1;
                inner_count = inner_count + 1;
                if (inner_count == x) {
                    break 'outer;
                };
                if (sum > 100) {
                    break;
                }
            }
        }
        sum
    }

    // Runner function calls all functions without arguments or with default args
    public fun runner(): u8 {
        let a = add(1, 2);
        let b = neg_bool(true);
        let c = match_on_u8(0);
        let d = match_tuple(0, 1);
        let e = control_flow_labels(10);
        a + (if b {1} else {0}) + c + d + e as u8
    }
}
//# run 0xCAFE::OperatorMatch::runner

// -----------------------------------------
//# run
script {
    fun main() {
        let a = 3u8;
        let b = 4u8;

        // Test arithmetic
        let res = 0xCAFE::OperatorMatch::add(a, b);

        // Test match
        let m = 0xCAFE::OperatorMatch::match_on_u8(res);

        // Test label based control flow
        let cf = 0xCAFE::OperatorMatch::control_flow_labels(5);

        // No asserts necessary but just to exercise VM running
        let _ = res + m + cf;
    }
}

// Featurres:
// 41bd86b64e2f4b17255c024cdc513f19: Apply unary or binary operators, including specification-only operators in spec blocks.
// dd45b96ea0255dd2bc3c9268e179045c: Write match expressions using the syntax `match (<exp>) { <arms> }` to perform pattern matching in Move code.
// e04f4e6393f3cc70f5b7a7eb7c919001: Replace block or label references with a new label during control flow graph transformations
