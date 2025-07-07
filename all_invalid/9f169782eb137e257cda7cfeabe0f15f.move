
//# publish
module 0xCAFE::TupleAndString {
    use std::vector;
    use std::string;

    // A function that returns a tuple of (starting_index, length)
    // Finds the index of first non-space byte and counts length without leading spaces
    public fun trim_leading_spaces(s: vector<u8>): (u64, u64) {
        let len = vector::length(&s);
        let start = 0u64;
        while (start < len && *vector::borrow(&s, start as u64) == b' ') {
            start = start + 1;
        };
        let length = len - start;
        (start, length)
    }

    // A function that takes a tuple argument and returns a trimmed vector<u8> slice
    public fun slice_trimmed_string(s: vector<u8>, indices: (u64, u64)): vector<u8> {
        let (start, length) = indices;
        vector::slice(&s, start, length)
    }

    // Function that combines both: given vector<u8>, returns trimmed vector<u8>
    public fun trim_string(s: vector<u8>): vector<u8> {
        let indices = trim_leading_spaces(s);
        slice_trimmed_string(s, indices)
    }

    // Demonstrate generic struct with 3 type parameters automatically generated with numbering
    struct TripleGen<T1, T2, T3> has copy, drop, store {
        a: T1,
        b: T2,
        c: T3,
    }

    // Function to create TripleGen given 3 values
    public fun make_triple_gen<T1, T2, T3>(a: T1, b: T2, c: T3): TripleGen<T1, T2, T3> {
        TripleGen<T1, T2, T3> {a, b, c}
    }

    public fun runner() {
        let s = b"   Move Language".to_vector();
        let trimmed = trim_string(s);
        vector::empty<u8>(); // dummy noop usage of vector to silence unused warning
        
        let triple = make_triple_gen<u8, bool, vector<u8>>(1u8, true, trimmed);
        let _ = triple.a;
        let _ = triple.b;
        let _ = triple.c;
    }
}


//# run 0xCAFE::TupleAndString::runner


// Featurres:
// 06b69eba2cdc705b765dac83e4f8a460: Declare and use tuple and multiple return or argument types in function signatures.
// 1f495184cd9e63c6fbe33e7e472d1c91: Use this function to remove leading whitespace characters from a string.
// 747b4002faaa7e337217152de6e1ffb0: Automatically generate type parameter syntax with proper formatting and numbering.
