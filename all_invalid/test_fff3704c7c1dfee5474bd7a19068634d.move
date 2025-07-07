//# publish
module 0x123::NestedStructTest {
    use 0x1::vector as V;

    // Utility function to iterate over mutable reference to nested structs within vectors and apply a function
    public inline fun for_each_nested_ref_mut<Element>(v: &mut vector<Element>, f: |&mut Element|) {
        let i = 0;
        while (i < V::length(v)) {
            f(V::borrow_mut(v, i));
            i = i + 1;
        }
    }

    // Structure of nested structs
    struct Inner<K, V> has drop {
        key: K,
        value: V,
    }
    struct Outer<K, V> has drop {
        inner_structs: vector<Inner<K, V>>,
        counter: u64,
    }

    // Function that applies a function to accumulate over nested structs' mutable fields
    inline fun accumulate_nested<K, V>(v: &mut vector<Outer<K, V>>, f: |&K, &mut V|u64): u64 {
        let total = 0;
        let i = 0;
        while (i < V::length(v)) {
            let outer_ref = V::borrow_mut(v, i);
            // Iterate over inner_structs within each Outer
            for_each_nested_ref_mut(&mut outer_ref.inner_structs, |inner| {
                total = total + f(&inner.key, &mut inner.value);
            });
            outer_ref.counter = outer_ref.counter + 1; // mutate outer
            i = i + 1;
        };
        total
    }

    public fun test() {
        let inner_vec1 = V::empty<Inner<u8, u64>>();
        let inner_vec2 = V::empty<Inner<u8, u64>>();

        // Initialize nested structs with values
        let inner1 = Inner { key: 1, value: 10 };
        let inner2 = Inner { key: 2, value: 20 };
        V::push_back(&mut inner_vec1, inner1);
        V::push_back(&mut inner_vec2, inner2);

        // Initialize outer structs
        let outer1 = Outer { inner_structs: inner_vec1, counter: 0 };
        let outer2 = Outer { inner_structs: inner_vec2, counter: 0 };

        let mut outer_vec = V::empty<Outer<u8, u64>>();
        V::push_back(&mut outer_vec, outer1);
        V::push_back(&mut outer_vec, outer2);
        
        // Use accumulate_nested to sum all inner values, and increment counters
        let sum = accumulate_nested(&mut outer_vec, |k, v| *k as u64 + *v);
        // The sum should be: (1 + 10) + (2 + 20) = 11 + 22 = 33
        // The counters in each outer should be incremented
        assert!(sum == 33, 0);

        // Verify that counters have been incremented
        let outer0 = V::borrow(&outer_vec, 0);
        let outer1 = V::borrow(&outer_vec, 1);
        assert!(outer0.counter == 1, 0);
        assert!(outer1.counter == 1, 0);
    }
}

//# run 0x123::NestedStructTest::test