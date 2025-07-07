
//# publish
module 0xDEAD::PatternMatchingTest {
    use std::vector;

    struct W has copy, drop {
        a: u64,
        b: u64,
    }

    public fun test_destructuring_and_move() {
        // Pattern match on a tuple with destructuring
        let (x, y): (u64, u64) = (10, 20);
        // Pattern match on a struct
        let w = W {a: 100, b: 200};
        let W {a: a_val, b: b_val} = w;

        // Copy u64 value and move W struct
        let c: u64 = x;
        let d: u64 = y;

        // Call functions to verify copying/moving semantics
        process_u64(c);
        process_u64(d);
        process_W(w);

        // Use vector to force some operations
        let vec: vector<u64> = vector::empty();
        vector::push_back(&vector, c);
        vector::push_back(&vector, d);
        let _ = vector::pop_back(&mut vec);
        let _ = vector::pop_back(&mut vec);
    }

    fun process_u64(value: u64) {
        // Function that consumes a copy of u64
        let _ = value;
    }

    fun process_W(w: W) {
        // Function that consumes W by move
        let _ = w;
    }

    public fun test_mutable_update() {
        let counter: u64 = 0;
        let limit: u64 = 5;

        let i: u64 = 0;
        while (i < limit) {
            counter = counter + 1;
            i = i + 1;
        };

        // After loop, counter should be equal to 'limit'
        assert!(counter == 5, 999);
    }
}


//# run 0xDEAD::PatternMatchingTest::test_destructuring_and_move

//# run 0xDEAD::PatternMatchingTest::test_mutable_update


// Featurres:
// 5187b41ec9bb6cdd91f86da1b90607bb: Pattern match on variables and destructure complex data types in assignment left-hand sides.
// 52a81d03e41c5bbaaad10ea91fc12692: Test that copying and moving `u64` and `W` values correctly preserves or transfers ownership during function calls without runtime errors.
// 11aa254fc6653291f12e715c6824522d: Test that mutably updating a local variable within a loop correctly modifies its value and reaches the expected assertion.
