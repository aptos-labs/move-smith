
//# publish
module 0xCAFE::QuantifierTest {
    use std::vector;
    use std::signer;

    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    /// Native function to test native function integration
    native public fun native_sum(a: u8, b: u8): u8;

    public fun test_quantifiers(): bool {
        // forall x in 0..5, x < 5
        let all_less = forall x in 0..5 : (x < 5);
        // exists x in 0..5, x == 3
        let exists_three = exists y in 0..5 : (y == 3);

        // forall pair in vector of Pairs, condition on fields
        let pairs = vector[
            Pair {a: 1, b: 2},
            Pair {a: 3, b: 4},
            Pair {a: 5, b: 6}
        ];
        // using witness expression _ in vector length
        let all_pairs_ok =
            forall i in 0..(vector::length(&pairs)) : ({
                let ref = vector::borrow(&pairs, i);
                ref.a < ref.b
            });

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


// Featurres:
// 8c62fe7656b5a212416706b16db90891: Write quantified expressions (forall/exists) over variable bindings and ranges, optionally using witness/condition expressions.
// 16697d963380114940c1851f50dab05a: Bind variables to struct destructuring patterns using `{}` syntax
// cb2d48b351c3c55b97a8fc4ba45e4001: Use different function body types, such as defined or native, with appropriate validation.
