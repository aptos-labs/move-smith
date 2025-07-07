//# publish
module 0x42::m {
    enum Data has drop {
        V1{x: u64},
        V2{x: u64, y: bool}
    }

    fun get_y(self: &Data): bool {
        match (self) {
            V2{x: _, y} => *y,
            _ => abort 33
        }
    }

    fun test_get_x_v1(): u64 {
        let d = Data::V1{x: 100};
        d.x
    }

    fun test_get_x_v2(): u64 {
        let d = Data::V2{x: 200, y: false};
        d.x
    }

    fun test_get_y_v1(): bool {
        let d = Data::V1{x: 300};
        d.get_y()
    }

    fun test_get_y_v2(): bool {
        let d = Data::V2{x: 400, y: true};
        d.get_y()
    }
}

//# run 0x42::m::test_get_x_v1

//# run 0x42::m::test_get_x_v2

//# run 0x42::m::test_get_y_v1

//# run 0x42::m::test_get_y_v2

//# publish
module 0x42::TestInteraction {
    use 0x1::vector as V;

    // Allows mutable iteration over vector elements
    public inline fun for_each_ref_mut<Element>(v: &mut vector<Element>, f: |&mut Element|) {
        let i = 0;
        while (i < V::length(v)) {
            f(V::borrow_mut(v, i));
            i = i + 1
        }
    }

    // Performs operation on each element, mutating `v` and summing `k`
    public inline fun elem_for_each_ref<K, V>(v: &mut vector<Elem<K, V>>, f: |&K, &mut V|u64): u64 {
        let result = 0;
        let mut i = 0;
        while (i < V::length(v)) {
            let elem = V::borrow_mut(v, i);
            result = result + f(&elem.k, &mut elem.v);
            i = i + 1;
        }
        result
    }

    struct Elem<K, V> has drop {
        k: K,
        v: V
    }

    public fun test_mutate_and_sum(): u64 {
        let mut v = vector[Elem{k: 10, v: 5}, Elem{k: 20, v: 15}];
        // Double each v
        let sum = elem_for_each_ref(&mut v, |key: &u64, val: &mut u64| {
            *val = *val * 2;
            *key
        });
        // Confirm the values are doubled
        let total_v: u64 = V::fold(&v, 0, |acc: u64, elem: &Elem<u64, u64>| {
            acc + elem.v
        });
        // total_v should be (10*2 + 20*2) = 60
        assert!(total_v == 60, 88);
        sum
    }
}

//# run 0x42::TestInteraction::test_mutate_and_sum