
//# publish
module 0xCAFE::LoopsAndData {
    use std::vector;

    struct Pair has copy, drop, store {
        a: u64,
        b: u64,
    }

    struct Container has copy, drop, store {
        pairs: vector<Pair>
    }

    public fun nested_for_loops(): u64 {
        let sum = 0u64;
        for (i in 1..4) {
            for (j in 1..3) {
                sum = sum + i * j;
            };
        };
        sum
    }

    public fun loop_with_empty_body(): u64 {
        let x = 0u64;
        for (_i in 0..5) {
            // empty body
        };
        while (x < 5) {
            // empty body
            x = x + 1;
        };
        loop {
            // empty body and break immediately
            break;
        };
        x
    }

    public fun vector_pack_structs(): u64 {
        let container = Container { pairs: vector::empty<Pair>() };
        let p1 = Pair { a: 10u64, b: 20u64 };
        let p2 = Pair { a: 30u64, b: 40u64 };
        vector::push_back(&mut container.pairs, p1);
        vector::push_back(&mut container.pairs, p2);

        let s = 0u64;
        for (p in &container.pairs) {
            s = s + p.a + p.b;
        };
        s
    }
}


//# run 0xCAFE::LoopsAndData::nested_for_loops


//# run 0xCAFE::LoopsAndData::loop_with_empty_body


//# run 0xCAFE::LoopsAndData::vector_pack_structs


// Featurres:
// 838ed5579f230c84b221c30b884415c8: Test that nested for-in loops over integer ranges correctly maintain and update loop variables and compute the expected final result.
// 90b396f0cda421632ed164532a7cc258: Create loop expressions with optional bodies.
// 01ae92f613b94402c9424ee4c7f6b9a1: Write expressions involving vectors, packs, and structured data.
