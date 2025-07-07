
//# publish
module 0xCAFE::VectorStructsV2 {
    // Test generic vector manipulations, mutable borrows, closures, and advanced Move v2 features

    use std::vector;
    use std::option;

    /// Nested struct representing a subfield to test borrowing nested fields
    struct Nested has copy, drop, store {
        flag: bool,
    }

    /// Primary struct stored in the vector; contains multiple fields including nested struct
    struct Elem has copy, drop, store {
        key: u64,
        val: u64,
        nested: Nested,
    }

    /// Creates a vector of Elem with `count` elements, keys from 0..count-1, vals equal to key*10, nested.flag alternating true/false
    public fun create_elems(count: u64): vector<Elem> {
        let v = vector::empty<Elem>();
        let i = 0u64;
        while (i < count) {
            let e = Elem {
                key: i,
                val: i * 10,
                nested: Nested { flag: (i % 2 == 0) }
            };
            vector::push_back(&mut v, e);
            i = i + 1;
        };
        v
    }

    /// Generic mutable for-each: takes mutable vector and a mutating closure; calls closure on each element mutable reference
    public fun for_each_mut<T>(v: &mut vector<T>, mut op: |&mut T|) {
        let len = vector::length<T>(v);
        let i = 0;
        while (i < len) {
            let elem_ref: &mut T = vector::borrow_mut<T>(v, i);
            op(elem_ref);
            i = i + 1;
        };
    }

    /// Increment the val field of each element by 1 using a closure, demonstrating in-place update and field destructuring
    public fun increment_all_vals(v: &mut vector<Elem>) {
        for_each_mut<Elem>(v, |e: &mut Elem| {
            e.val = e.val + 1;
        });
    }

    /// Flip the nested.flag boolean of each element
    public fun flip_flags(v: &mut vector<Elem>) {
        for_each_mut<Elem>(v, |e: &mut Elem| {
            let Nested { flag: f } = e.nested;
            // Use struct update syntax from Move v2: create new Nested with flipped flag
            e.nested = Nested { flag: !f };
        });
    }

    /// Simultaneous mutable borrows of multiple fields: increments key by 100 and val by 200 in each element
    public fun incr_key_and_val_simultaneous(v: &mut vector<Elem>) {
        for_each_mut<Elem>(v, |e: &mut Elem| {
            let k_ref: &mut u64 = &mut e.key;
            let val_ref: &mut u64 = &mut e.val;
            *k_ref = *k_ref + 100;
            *val_ref = *val_ref + 200;
        });
    }

    /// Runner function: creates a vector with 5 elements, applies all mutations in sequence
    /// Returns the resulting vector for external inspection
    public fun runner(): vector<Elem> {
        let v = create_elems(5);
        increment_all_vals(&mut v);
        flip_flags(&mut v);
        incr_key_and_val_simultaneous(&mut v);
        v
    }
}


//# run 0xCAFE::VectorStructsV2::create_elems --args 3u64


//# run 0xCAFE::VectorStructsV2::increment_all_vals --args (vector[
    0xCAFE::VectorStructsV2::Elem {
        key: 1u64,
        val: 10u64,
        nested: 0xCAFE::VectorStructsV2::Nested {flag: true}
    },
    0xCAFE::VectorStructsV2::Elem {
        key: 2u64,
        val: 20u64,
        nested: 0xCAFE::VectorStructsV2::Nested {flag: false}
    }
])


//# run 0xCAFE::VectorStructsV2::flip_flags --args (vector[
    0xCAFE::VectorStructsV2::Elem {
        key: 3u64,
        val: 40u64,
        nested: 0xCAFE::VectorStructsV2::Nested {flag: false}
    },
    0xCAFE::VectorStructsV2::Elem {
        key: 4u64,
        val: 50u64,
        nested: 0xCAFE::VectorStructsV2::Nested {flag: true}
    }
])


//# run 0xCAFE::VectorStructsV2::incr_key_and_val_simultaneous --args (vector[
    0xCAFE::VectorStructsV2::Elem {
        key: 5u64,
        val: 60u64,
        nested: 0xCAFE::VectorStructsV2::Nested {flag: true}
    },
    0xCAFE::VectorStructsV2::Elem {
        key: 6u64,
        val: 70u64,
        nested: 0xCAFE::VectorStructsV2::Nested {flag: false}
    }
])


//# run 0xCAFE::VectorStructsV2::runner


// Featurres:
// 953dd007bdb1381c942fce08ed6a91fb: Use vector types to handle collections of elements of a specific type.
// 8ac46363ee65333fafab3c5023197f9e: Test that a for-each function can safely mutate elements and destructure fields by mutable reference within a generic vector, including borrowing both keys and values mutably in a custom struct.
// 624e62dedded7dc7e504e3fba5ec4365: Write code that uses features exclusive to Move language version 2 or higher
