//# publish
module 0x42::NestedStructTest {
    use 0x1::vector as V;

    // Utility to iterate over mutable references in a vector of nested structs
    public inline fun for_each_ref_mut<Element>(v: &mut vector<Element>, f: |&mut Element|) {
        let i = 0;
        while (i < V::length(v)) {
            f(V::borrow_mut(v, i));
            i = i + 1;
        }
    }

    // Define nested structs with different levels
    struct Inner<K, V> has drop {
        key: K,
        value: V
    }

    struct Outer<K, V> has drop {
        id: K,
        inner: Inner<K, V>
    }

    // Function to apply a mutable operation on nested fields within vector of Outer structs
    public inline fun nested_structs_accumulate<K, V>(
        v: &mut vector<Outer<K, V>>,
        f: |&K, &mut V|u64
    ): u64 {
        let total = 0;
        for_each_ref_mut(v, |outer| {
            // apply function on outer 'id' and inner 'value'
            total = total + f(&outer.id, &mut outer.inner.value);
        });
        total
    }

    public fun test() {
        // Prepare vector with nested structs
        let mut vec = vector[
            Outer { id: 10, inner: Inner { key: 100, value: 5 } },
            Outer { id: 20, inner: Inner { key: 200, value: 15 } },
            Outer { id: 30, inner: Inner { key: 300, value: 25 } }
        ];
        // Sum the 'id' and 'value' fields, multiplying the value by 2
        let sum = nested_structs_accumulate(&mut vec, |id_ref, val_mut| *id_ref as u64 + (*val_mut * 2));
        // The sum should be: (10 + 5*2) + (20 + 15*2) + (30 + 25*2) = 10 + 10 + 20 + 30 + 50 = 120
        assert!(sum == 120, 0);
    }
}

//# run 0x42::NestedStructTest::test