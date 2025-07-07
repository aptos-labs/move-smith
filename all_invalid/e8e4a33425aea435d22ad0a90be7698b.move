// Example transactional test for Aptos Move compiler & VM

//# publish
module 0xCAFE::VecOptionIterTest {
    use std::vector;
    use std::option::{Self, Option};
    
    // Swaps two u64 values. Returns (b, a)
    public fun swap(a: u64, b: u64): (u64, u64) {
        (b, a)
    }

    // Applies a provided function to every vector inside the option<vector<T>>
    // (In practice, closure/lambda passing isn't supported, so we'll just do some action inline)
    // For this demo, we collect the sum of each vector into result.
    public fun iterate_optional_vecs(opt_vecs: Option<vector<vector<u64>>>): u64 {
        let total = 0u64;
        match opt_vecs {
            Option::Some(vecs) => {
                let i = 0;
                let n = vector::length(&vecs);
                while (i < n) {
                    let v = vector::borrow(&vecs, i);
                    // Sum elements in this vector and add to total
                    let j = 0;
                    let m = vector::length(v);
                    let subtotal = 0u64;
                    while (j < m) {
                        let elem = *vector::borrow(v, j);
                        subtotal = subtotal + elem;
                        j = j + 1;
                    };
                    total = total + subtotal;
                    i = i + 1;
                };
                total
            },
            Option::None => 0u64 // No vectors
        }
    }

    // Test block: Swap and also compose sequence of statements in a block
    public fun test(): bool {
        // Move block with variable declarations + statements
        let (x, y) = (10u64, 42u64);
        let (a, b) = swap(x, y);
        let sum = a + b;
        sum == 52u64 && a == 42u64 && b == 10u64
    }

    // Runner function for the test
    public fun runner() {
        assert!(test(), 100);
    }

    public fun main() {
        // Compose a sequence of statements in a Move block
        let v1 = vector::empty<u64>();
        vector::push_back(&mut v1, 1);
        vector::push_back(&mut v1, 2);

        let v2 = vector::empty<u64>();
        vector::push_back(&mut v2, 10);
        vector::push_back(&mut v2, 20);

        let vv = vector::empty<vector<u64>>();
        vector::push_back(&mut vv, v1);
        vector::push_back(&mut vv, v2);

        let opt_vv = Option::some<vector<vector<u64>>>(vv);

        let sum = iterate_optional_vecs(opt_vv);
        assert!(sum == 33u64, 200); // (1+2) + (10+20) = 3 + 30 = 33

        let none_vecs = Option::none<vector<vector<u64>>>();
        let sum2 = iterate_optional_vecs(none_vecs);
        assert!(sum2 == 0u64, 201);
    }
}
//# run 0xCAFE::VecOptionIterTest::runner
//# run 0xCAFE::VecOptionIterTest::main

//# run
script {
    fun main() {
        // Compose sequence of blocks and assign
        let a = 7u64;
        let b = 13u64;
        // Inner block
        {
            let swap_a = a;
            let swap_b = b;
            let (out_b, out_a) = 0xCAFE::VecOptionIterTest::swap(swap_a, swap_b);
            assert!(out_a == a && out_b == b, 2);
            assert!(out_b == 13u64 && out_a == 7u64, 3);
        }
    }
}

// Features:
// 8098ba46b0fc6bb01717d129f465958f: Iterate over optional vectors of types with for_each to perform an action on each contained vector of types.
// 2c09ac38518b56030fe2a90d628d7ce4: Test that the `test` function correctly swaps two u64 values and that the `main` function verifies this swap by asserting the expected results.
// 4bb18516d182013308cd1c037e8eb3de: Write sequences of statements in Move blocks.