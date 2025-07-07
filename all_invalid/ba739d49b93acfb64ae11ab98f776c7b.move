
//# publish
module 0xCAFE::AdvancedMatch {
    use std::vector;

    struct Data has copy, drop, store {
        x: u8,
        y: u8,
        z: u8,
    }

    enum Choice {
        A,
        B(u8),
        C { a: bool, b: u8 },
        D(u8, u8, u8),
    }

    public fun test_wildcard_pattern_match(c: Choice): u8 {
        let result;
        match (c) {
            Choice::A => {
                result = 1;
            },
            Choice::B(_) => {
                // Use wildcard to ignore the inner value
                result = 2;
            },
            Choice::C { a: _, b } => {
                // Ignore a, use b
                result = b;
            },
            Choice::D(_, y, _) => {
                // Ignore first and last, use middle
                result = y;
            },
        };
        result
    }

    public fun test_wildcard_assignment(): u8 {
        let (a, _, c) = (5u8, 10u8, 15u8);
        let (x, y, _) = (1u8, 2u8, 3u8);
        a + c + x + y
    }

    spec {
        spec fun spec_add(x: u8, y: u8): u8;
        spec fun spec_fold(v: vector<u8>): u8 {
            let sum = 0u8;
            let len = vector::length(&v);
            let i = 0;
            while (i < len) {
                sum = sum + *vector::borrow(&v, i);
                i = i + 1;
            };
            sum
        }
    }

    // inline]
    public spec fun spec_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun wrapper_assignable_expr(x: u8, y: u8): u8 {
        let add_fn = |a: u8, b: u8| a + b;
        // Wrap the function call expression inside parentheses to make it an assignable value for return
        (add_fn(x, y))
    }

    public fun runner(): u8 {
        let c1 = Choice::B(7);
        let v = vector[1u8, 2u8, 3u8];
        let w1 = test_wildcard_pattern_match(c1);
        let w2 = test_wildcard_assignment();
        let w3 = wrapper_assignable_expr(4u8, 5u8);
        // Call spec function in spec block only, so no call here.
        w1 + w2 + w3
    }
}


//# run 0xCAFE::AdvancedMatch::runner


// Featurres:
// f86b02c97d995c7ef7900cd270b1c508: Bind values to a wildcard variable '_' in pattern matching or assignments to ignore them in Move programs
// 9603912541cbfa8a6e2cb5d75712a7ac: Define specification functions using spec fun with full Move-like function signatures in spec blocks.
// 7a53d096437efb378d0344d200dfdaa8: Wrap other expressions as assignable values for general case.
