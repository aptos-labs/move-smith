//# publish
module 0xCAFE::CopyMoveTest {
    use std::vector;
    use std::debug;

    struct Container has copy, drop, store {
        data: vector<u8>
    }

    public fun test_sequence_statements(): u8 {
        let x = 5u8;
        let y = 10u8;
        let mut sum = x + y;
        let z = if (sum > 10) {
            20u8
        } else {
            0u8
        };
        sum = sum + z;
        assert!(sum == 35, 1000);
        sum
    }

    public fun test_copy_and_move(): u8 {
        let v = vector::empty<u8>();
        vector::push_back(&mut (v), 1u8);
        vector::push_back(&mut (v), 2u8);

        let container = Container { data: copy v };
        let moved_container = container;
        // container is moved now, we cannot use it

        let copied_container = copy moved_container;
        let first = *vector::borrow(&copied_container.data, 0);
        let second = *vector::borrow(&copied_container.data, 1);
        first + second
    }

    public fun inline_loop_with_break(): u8 {
        let v = vector::empty<u8>();
        vector::push_back(&mut (v), 1u8);
        vector::push_back(&mut (v), 2u8);
        vector::push_back(&mut (v), 3u8);

        let mut sum = 0u8;
        let len = vector::length(&v);
        let mut i = 0;
        loop {
            if (i == len) {
                break;
            };
            let val = *vector::borrow(&v, i);
            if (val == 2u8) {
                break;
            };
            sum = sum + val;
            i = i + 1;
        };
        sum
    }

    public fun non_inline_loop_with_break(): u8 {
        let v = vector::empty<u8>();
        vector::push_back(&mut (v), 4u8);
        vector::push_back(&mut (v), 5u8);
        vector::push_back(&mut (v), 6u8);

        let mut sum = 0u8;
        let len = vector::length(&v);
        let mut i = 0;
        let loop_lambda: |&vector<u8>, u8, u8| u8 has copy+drop =
            |vec_ref: &vector<u8>, start: u8, end: u8| {
                let mut acc = 0u8;
                let mut idx = start;
                loop {
                    if (idx == end) {
                        break;
                    };
                    acc = acc + *vector::borrow(vec_ref, idx);
                    idx = idx + 1;
                };
                acc
            };
        sum = loop_lambda(&v, i, len);
        sum
    }

    public fun runner(): u8 {
        let a = test_sequence_statements();
        let b = test_copy_and_move();
        let c = inline_loop_with_break();
        let d = non_inline_loop_with_break();

        // Use debug::print for side effects, won't fail since no assert
        debug::print(b"Runner executed\n");

        a + b + c + d
    }
}

//# run 0xCAFE::CopyMoveTest::runner

// Featurres:
// 3844037abe07b694aec1e9b6a3727ca9: Provide a function body implementation using a sequence of statements and expressions.
// b96217ac07ec5a0c51c55732093eff32: Use the copy and move keywords to control variable semantics in expressions.
// 2b85fce2b17f6276e81f4a5d2d32f9bc: Test that copying a vector of u8 values in Move does not cause invariant violations, especially when using functions with inline or non-inline loops containing break statements.
