
//# publish
module 0xCAFE::MatchAndVectorTest {
    use std::vector;

    // Function to test pattern matching with variants and bindings
    public fun match_enum(e: E): u64 {
        match (e) {
            E::V1 => 1,
            E::V2(x, y) if (x + y > 10) => 2,
            E::V2(x, y) => 3,
            E::V3 { a } if (a) => 4,
            E::V3 { a } => 5,
        }
    }

    // Function to construct and return a vector of u8
    public fun create_vector() acquires vector::Vector<u8> {
        let vec: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut vec, 10);
        vector::push_back(&mut vec, 20);
        vector::push_back(&mut vec, 30);
        vec
    }

    // Inline recursive function that tries to call itself to create a cycle
    public inline fun recursive_inline_fun(n: u64): u64 {
        if (n == 0) {
            0
        } else {
            // Intentionally recursive inline call - should test compiler detection or inlining
            n + recursive_inline_fun(n - 1)
        }
    }

    // Function to call recursive_inline_fun to exercise inline function inlining and detect cycle
    public fun call_recursive(n: u64): u64 {
        recursive_inline_fun(n)
    }
}


//# run 0xCAFE::MatchAndVectorTest::match_enum --args 0u64

//# run 0xCAFE::MatchAndVectorTest::match_enum --args 12u64

//# run 0xCAFE::MatchAndVectorTest::match_enum --args 0u64


//# run 0xCAFE::MatchAndVectorTest::create_vector


//# run 0xCAFE::MatchAndVectorTest::call_recursive --args 5u64

// Featurres:
// a505f5e72b94cdca41c2b5cd3bf6fdae: Match expressions against patterns using match arms, including with pattern bindings and optional conditions.
// d7f3dba58bc17d0cdfda8948adcd7a5e: Construct vectors with `Vector` expressions.
// 849cdc3430d3537a79447731cdcfa751: Detect and prevent cyclic calls between inline functions to avoid infinite inlining.
