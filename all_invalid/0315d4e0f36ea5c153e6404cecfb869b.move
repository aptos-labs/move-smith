
//# publish
module 0xCAFE::TupleAndString {
    use std::vector;

    // A struct to represent indices since tuple types are not allowed
    struct Indices has copy, drop, store {
        start: u64,
        length: u64,
    }

    // A function that returns Indices with (starting_index, length)
    // Finds the index of first non-space byte and counts length without leading spaces
    public fun trim_leading_spaces(s: &vector<u8>): Indices {
        let len = vector::length(s);
        let start = 0u64;
        // Use while loop within Move's restricted syntax by a recursive style or loop with mut var
        while (start < len && *vector::borrow(s, start) == 0x20) {
            start = start + 1;
        };
        let length = len - start;
        Indices { start, length }
    }

    // A function that takes Indices argument and returns a trimmed vector<u8> slice
    public fun slice_trimmed_string(s: &vector<u8>, indices: Indices): vector<u8> {
        // vector::sub_range is available for slicing (start inclusive, end exclusive)
        vector::sub_range(s, indices.start, indices.start + indices.length)
    }

    // Function that combines both: given vector<u8>, returns trimmed vector<u8>
    public fun trim_string(s: vector<u8>): vector<u8> {
        let indices = trim_leading_spaces(&s);
        slice_trimmed_string(&s, indices)
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

    public fun runner() acquires Indices {
        // Use vector::from_bytes to create a vector<u8> from a byte array literal
        let s = vector::from_bytes(b"   Move Language");
        let trimmed = trim_string(s);
        vector::empty<u8>(); // dummy noop usage of vector to silence unused warning
        
        let triple = make_triple_gen<u8, bool, vector<u8>>(1u8, true, trimmed);
        let _ = triple.a;
        let _ = triple.b;
        let _ = triple.c;
    }
}


//# run 0xCAFE::TupleAndString::runner
