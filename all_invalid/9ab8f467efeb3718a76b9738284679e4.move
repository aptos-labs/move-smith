//# publish
module 0xCAFE::PunctGroupTest {
    use std::vector;

    // Test various punctuation and grouping in constants
    const V1: vector<u8> = vector[1u8, 2u8, 3u8]; // []
    const TUP: (u8, u64, bool) = (9u8, 100u64, false); // ()
    const NESTED_VECS: vector<vector<u8>> = vector[
        vector[1u8, 2u8],
        vector[3u8, 4u8]
    ]; // nested [] and grouping

    // {} in struct definitions
    struct FieldTest {
        x: u64,
        y: u8,
    }

    // # is not currently used in Move except in comments and some macros, 
    // which don't exist. We'll use it in a comment.
    // Example: # This is a comment using #
    // Similarly, @ is reserved for attributes, but in Move only #[...] is supported for test functions.

    // Testing field writes; method sets field via assignment (.)
    public fun set_x(v: &mut FieldTest, new_x: u64) {
        v.x = new_x; // (.) and assignment (=)
    }

    // Test vector::map with nested vectors in constants and closure referencing its argument
    public fun map_nested_add(
        nested: &vector<vector<u8>>,
        add_to: u8
    ): vector<vector<u8>> {
        vector::map(nested, fun (inner: &vector<u8>): vector<u8> {
            vector::map(inner, fun (elem: &u8): u8 {
                *elem + add_to // Reference argument and compute (+)
            })
        }) // nested map, closures over args, grouping(parens/braces)
    }

    // Test tuple destructuring with grouping and tuple
    public fun destructure_tuple(): u8 {
        let (a, b, c) = TUP; // () grouping, tuple destructure
        a
    }

    public fun test_dot_range(): bool {
        let v = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        let slice = vector::sub_range(&v, 1, 4); // [1,4) simulates a . .
        // Range here is expressed as start/end pair; no native .. syntax, but tests grouping and commas.
        slice == vector[2u8, 3u8, 4u8]
    }

    public fun runner() {
        // Test field assignment
        let mut ft = FieldTest {x: 10, y: 4};
        set_x(&mut ft, 555);
        let old_y = ft.y;
        ft.y = 42; // Write to y; should update field. Tests . and = on LHS.
        // Test vector::map with NESTED_VECS const
        let result1 = map_nested_add(&NESTED_VECS, 5u8);
        // Test destructuring
        let _a = destructure_tuple();
        let _ok = test_dot_range();
        // {} for block/grouping
        {
            let _tmp = 10u8;
        }
    }
}
//# run 0xCAFE::PunctGroupTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::PunctGroupTest::{FieldTest, set_x, map_nested_add};

    fun main(account: &signer) {
        // Create struct, assign fields.
        let mut s = FieldTest {x: 1, y: 2};
        set_x(&mut s, 42);
        s.y = s.y + 9; // Field write on LHS, . operator

        // Map over const nested vector
        let nested = vector[vector[7u8,8u8], vector[9u8]];
        let mapped = map_nested_add(&nested, 2u8);

        // Test grouping ()
        let (foo, bar) = (10u8, 99u8);
        let tuple = (foo, bar);

        // Use [] for vector creation
        let v = vector[tuple.0, tuple.1];

        // { } for block scoping
        {
            let _shadow = 1u8;
        }
        // # in comment; . in field, , in tuple, [] in vector literal, () in grouping
        // All grouping and punctuation covered.
    }
}

// Featurres:
// 39f7aae1912ff9e11c15a3c2ea0559c1: Use various punctuation and grouping characters such as (), [], {}, ,, ;, #, @, and . (dot/range).
// 37878dfc8ef016009d536159cf2eea24: Test that vector::map works correctly when applied to nested vectors stored in constants and that closures within map can reference their arguments and perform computations.
// 672648ae28d823ed2b04a70242c4f3bc: Use field writes (e.g., assign to a field of a struct) as a left-hand side of assignment.
