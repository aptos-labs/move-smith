
//# publish
module 0xCAFE::LetAndSpec {
    use std::vector;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Struct with key for storage testing
    struct StoredData has store, key {
        value: u64,
    }

    /// Function to test let-binding with symbolic identifier and complex expression
    public fun test_let_binding_and_expression(): u64 {
        let a = 4u64;
        let b = 5u64;
        let c = a * (b + 10u64);
        c
    }

    // test]
    spec test_spec {
        // Spec attribute on spec blocks to test attribute handling
        let expected: u64 = 20;
        // spec statement expression must have trailing semicolon
        assert!(expected == 20, 123);
    }

    // doc = "Test of Move 2.0 control-flow and struct update"]
    public fun move2_features(x: u8): u64 {
        let counter = 0u64;
        // match expression with multiple arms
        let answer = match (x) {
            0 => { counter += 1u64; 100u64 },
            1 => { counter += 10u64; 200u64 },
            _ => { counter += 100u64; 300u64 }
        };
        // Struct update using copy
        let p1 = Point { x: answer, y: counter };
        let p2 = Point { y: p1.y + 1, ..p1 };
        p2.x + p2.y
    }

    public fun store_struct(s: &signer, val: u64) {
        move_to<StoredData>(s, StoredData { value: val });
    }
}


//# run 0xCAFE::LetAndSpec::test_let_binding_and_expression


//# run 0xCAFE::LetAndSpec::move2_features --args 1u8


//# run 0xCAFE::LetAndSpec::store_struct --signers 0xABCD --args 42u64


// Featurres:
// 343df347c63616183bef714434732b09: Create a let-binding for a symbol with a specified expression.
// 6339137e67c7ba33d130dcba563938ba: Attach attributes to specification blocks.
// 94a28480ca8927038579fbe6a777d5bc: Use Move 2.0 language constructs in your Move code
