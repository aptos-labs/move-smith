//# publish
module 0x99::nested_structs {
    struct Inner has drop {
        value: u64,
        label: vector<u8>,
    }

    struct Outer has drop {
        id: u128,
        inner: Inner,
        count: u64,
    }

    public fun unpack_and_mutate(): () {
        let inn = Inner { value: 10, label: b"test".to_vec() };
        let mut outer = Outer { id: 42, inner: inn, count: 5 };
        // Dereference references to nested structs
        let Outer{ id, inner: ref mut inner_mut, count: ref mut cnt } = &mut outer;
        let Inner { value: ref mut v, label: ref lbl } = inner_mut;

        // Assertions before mutation
        assert!(*id == 42, 0);
        assert!(*cnt == 5, 1);
        assert!(*v == 10, 2);
        assert!(*lbl == b"test".to_vec(), 3);

        // Mutate nested fields
        *v = *v + 20;
        *cnt = *cnt + 1;
        inner_mut.label = b"modified".to_vec();
        *id = *id + 100;

        // Assertions after mutation
        assert!(*id == 142, 4);
        assert!(*cnt == 6, 5);
        assert!(*v == 30, 6);
        assert!(*inner_mut.label == b"modified".to_vec(), 7);
    }
}

//# run 0x99::nested_structs::unpack_and_mutate

//# publish
module 0x99::bit_shift_constants {
    const MASK_SHIFT_LEFT: u16 = 1 << 15;
    const MASK_SHIFT_RIGHT: u16 = 1 >> 1; // should be 0 since shifting right

    public fun compute_sum(): u16 {
        MASK_SHIFT_LEFT + MASK_SHIFT_RIGHT
    }
}

//# run 0x99::bit_shift_constants::compute_sum

//# publish
module 0x99::reference_function_traits {
    public fun simple_closure(): u64 {
        // Closure that doubles the input
        let f: |u64|u64 has drop+copy = |x| x * 2;
        helper_ref(&f, 4)
    }

    fun helper_ref(f: &|u64|u64 has copy, x: u64): u64 {
        (*f)(x)
    }

    public fun complex_closure(): u64 {
        let base_f: |u64|u64 has drop+copy = |x| x + 3;
        let mut f: &|u64|u64 has copy = &base_f;
        // Changing the reference to a new closure
        let new_f: |u64|u64 has drop+copy = |x| x * x;
        f = &new_f;
        helper_ref(f, 5)
    }
}

//# run 0x99::reference_function_traits::simple_closure
//# run 0x99::reference_function_traits::complex_closure