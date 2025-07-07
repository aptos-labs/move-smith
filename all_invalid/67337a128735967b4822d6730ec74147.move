//# publish
module 0xCAFE::PatternTest {
    use std::assert;

    struct Data has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
    }

    public fun foo(x: u8): u8 {
        1u8 + 1u8
    }

    public fun bar() {
        // This function asserts that foo(3) == 2
        assert!(foo(3) == 2, 1001);
    }

    public fun dotdot_pattern() {
        // Use .. to ignore remaining fields in struct pattern
        let data = Data {a: 10, b: 20, c: 30};
        let Data {a, ..} = data;
        assert!(a == 10, 1002);
    }

    public fun bind_pattern() {
        let tup = (5u8, 7u8);
        let (x, y) = tup;
        assert!(x == 5 && y == 7, 1003);
    }
}

//# run 0xCAFE::PatternTest::foo --args 3u8

//# run 0xCAFE::PatternTest::bar

//# run 0xCAFE::PatternTest::dotdot_pattern

//# run 0xCAFE::PatternTest::bind_pattern

// Featurres:
// 0ab78326b7412b7dcbf217da882c3957: Test that the function `foo` correctly returns the sum of 1 and 1, and verify that the `bar` function asserts `foo(3) == 2` successfully.
// a56262b170f67b534296aa6ded7843c2: Use '..' (dotdot) syntax in pattern matching to ignore the remaining fields of a struct.
// 884abbd2ebbe87091c9ba3136a9433bd: Bind variables with pattern matching in assignment statements using tuple destructuring.
