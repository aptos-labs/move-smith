
//# publish
module 0xCAFE::LiveIntervalTest {
    use std::signer;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Pair has copy, drop, store {
        first: u8,
        second: u8,
    }

    /// Inline specification example in Move with requires and ensures
    spec fun spec_example(x: u64, y: u64): u64
        requires x < 100
        ensures (result >= x);

    public fun spec_example(x: u64, y: u64): u64 {
        let label_start = x;
        let sum = x + y;
        let label_middle = sum;
        // Use a tuple and unpack it positionally
        let (a, b) = (label_start, label_middle);
        // Create struct by positional unpacking from tuple
        let p = Point {x: a, y: b};
        let Point {x: px, y: py} = p;
        // Label live interval end
        let label_end = px + py;
        label_end
    }

    // Label live interval in binding and destructuring tuples and structs
    public fun live_intervals_with_unpacking(): u8 {
        let pair = Pair {first: 10, second: 20};
        // Positional unpacking of struct fields
        let Pair {first: f, second: s} = pair;
        // Bind tuple directly with positional unpacking
        let (u, v) = (f, s);
        let sum = u + v;
        sum
    }

    public fun use_labeled_liveness(x: u8): u8 {
        let start = x;
        let a = start + 1;
        let live1 = a;
        {
            let b = live1 * 2; // b lives in this inner scope
            let live2 = b;
            live2;
        };
        let c = live1 + 3;
        let live3 = c;
        live3
    }
}



//# run 0xCAFE::LiveIntervalTest::spec_example --args 10u64 20u64



//# run 0xCAFE::LiveIntervalTest::live_intervals_with_unpacking



//# run 0xCAFE::LiveIntervalTest::use_labeled_liveness --args 5u8
