
//# publish
module 0xCAFE::QuantifierTest {
    use std::vector;

    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    /// Native function to test native function integration
    native public fun native_sum(a: u8, b: u8): u8;

    /// Specification-only function for quantifiers
    spec fun quantifiers_spec(): bool {
        // forall x in 0..5, x < 5
        let all_less = forall x in 0..5 : (x < 5);
        // exists x in 0..5, x == 3
        let exists_three = exists y in 0..5 : (y == 3);
        true
    }

    public fun test_quantifiers(): bool {
        // Normal Move code to manually check quantifiers since quantifiers only allowed in spec
        let all_less = true;
        let exists_three = false;

        let i = 0;
        while (i < 5) {
            if (!(i < 5)) {
                all_less = false;
            };
            if (i == 3) {
                exists_three = true;
            };
            i = i + 1;
        };

        let pairs = vector[
            Pair {a: 1, b: 2},
            Pair {a: 3, b: 4},
            Pair {a: 5, b: 6}
        ];

        let len = vector::length(&pairs);
        let all_pairs_ok = true;
        let j = 0;
        while (j < len) {
            let ref = vector::borrow(&pairs, j);
            if (!(ref.a < ref.b)) {
                all_pairs_ok = false;
            };
            j = j + 1;
        };

        all_less && exists_three && all_pairs_ok
    }

    public fun destructure_test(): u8 {
        let p = Pair {a: 10, b: 20};
        // Destructure with {}
        let Pair {a: x, b: y} = p;
        // return sum via native function
        native_sum(x, y)
    }

    public fun runner(): bool {
        let quantifier_result = test_quantifiers();
        let destruct_result = destructure_test();
        // Check destruct_result is 30 (10+20)
        let valid_destruct = destruct_result == 30;
        quantifier_result && valid_destruct
    }
}


//# run 0xCAFE::QuantifierTest::runner
