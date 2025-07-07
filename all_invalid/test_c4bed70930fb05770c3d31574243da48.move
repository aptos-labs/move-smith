//# publish
module 0x99::TestElemMutate {
    use 0x1::vector as V;

    // Utility function to iterate mutably over refs in vector elements
    public inline fun for_each_ref_mut<Element>(v: &mut vector<Element>, f: |&mut Element|) {
        let i = 0;
        while (i < V::length(v)) {
            f(V::borrow_mut(v, i));
            i = i + 1
        }
    }

    // Struct with keys and mutable value
    struct Elem<K, V> has drop {
        k: K,
        v: V,
    }

    // Function to test mutable iteration and summation over element fields
    public fun elem_for_each_ref<K, V>(v: &mut vector<Elem<K, V>>, f: |&K, &mut V| u64): u64 {
        let result = 0;
        // Mutably iterate over elements
        for_each_ref_mut(v, |elem: &mut Elem<K, V>| {
            let elem_ref: &mut Elem<K, V> = elem;
            result = result + f(&elem_ref.k, &mut elem_ref.v);
        });
        result
    }

    // Function to test incrementing the v fields then summing their values
    public fun test() {
        let mut elems = vector[
            Elem{k: 10, v: 5},
            Elem{k: 20, v: 15},
            Elem{k: 30, v: 25},
        ];
        // Define a function that increments v and returns v + k
        let sum_func = |key: &u64, val: &mut u64| -> u64 {
            *val = *val + 1;
            *key + *val
        };
        let result = elem_for_each_ref(&mut elems, sum_func);
        // Sum of keys after increment: (10+1) + (20+1) + (30+1) = 11+21+31=63
        // Values after increment: (5+1)=6, (15+1)=16, (25+1)=26
        // sum over all: 11+6 + 21+16 + 31+26 = (17+37+57) = 111
        assert!(result == 111, result);
        // Additionally, verify that each v has been incremented
        assert!(V::borrow(&elems, 0).v == 6, 0);
        assert!(V::borrow(&elems, 1).v == 16, 1);
        assert!(V::borrow(&elems, 2).v == 26, 2);
    }
}

//# run 0x99::TestElemMutate::test
