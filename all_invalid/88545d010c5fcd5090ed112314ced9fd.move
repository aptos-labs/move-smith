
//# publish
module 0xCAFE::IdDataAccessDeref {
    use std::vector;

    struct Inner has copy, drop, store {
        val: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        data: vector<u8>,
        arr: vector<Inner>,
    }

    // References are not allowed as struct fields in Move.
    // Instead, store addresses or indices or copy values as needed.
    // Here, we'll store copies of Outer, vector<u8>, and Inner in RefHolder.

    struct RefHolder has store {
        outer_copy: Outer,
        vec_copy: vector<u8>,
        inner_copy: Inner,
    }

    public fun create_outer(): Outer {
        let inner = Inner { val: 42u8 };
        let data = vector[10u8, 20u8, 30u8];
        let arr = vector[
            Inner { val: 1u8 },
            Inner { val: 2u8 },
            Inner { val: 3u8 }
        ];
        Outer { inner, data, arr }
    }

    public fun test_identifier_binding(): u8 {
        let x = 5u8;
        let y = x + 10u8;
        y
    }

    public fun test_field_access(o: &Outer): u8 {
        let v = o.inner.val;
        v
    }

    public fun test_index_access(o: &Outer): u8 {
        let v = *vector::borrow(&o.data, 1);
        v
    }

    public fun test_deref_immut_ref(o: &Outer): u8 {
        let inner_ref: &Inner = &o.inner;
        let val = (*inner_ref).val;
        val
    }

    public fun test_deref_mut_ref(o: &mut Outer): u8 {
        let inner_ref_mut: &mut Inner = &mut o.inner;
        inner_ref_mut.val = 100u8;
        (*inner_ref_mut).val
    }

    public fun test_combined_field_deref(o: &mut Outer): u8 {
        let inner_ref_mut: &mut Inner = &mut o.inner;
        let v: u8 = (*inner_ref_mut).val;
        v
    }

    public fun test_combined_index_deref(o: &Outer): u8 {
        let arr_ref: &vector<Inner> = &o.arr;
        let inner_at_index_ref: &Inner = vector::borrow(arr_ref, 0);
        let val = (*inner_at_index_ref).val;
        val
    }

    public fun test_ref_holder(o: &mut Outer): u8 {
        // Create copies instead of references for RefHolder
        let holder = RefHolder {
            outer_copy: *o,
            vec_copy: vector::clone(&o.data),
            inner_copy: o.inner,
        };
        let r = holder.outer_copy;
        let v = r.inner.val; // access using identifier and dotted expr

        let first_vec_val = *vector::borrow(&holder.vec_copy, 0);
        let inner_val = holder.inner_copy.val;
        v + first_vec_val + inner_val
    }

    // Intentionally invalid functions to provoke errors; commented out to allow compilation
    /*
    public fun invalid_deref_not_ref(x: u8): u8 {
        let y = *x; // error: cannot dereference non-reference
        y
    }

    public fun invalid_field_access(o: &Outer): u8 {
        let val = o.nonexistent_field; // error: no such field
        val
    }
    */

    // Runner function combining several tests with no args
    public fun runner(): u8 {
        let o = create_outer();
        let r1 = test_identifier_binding();
        let r2 = test_field_access(&o);
        let r3 = test_index_access(&o);
        let r4 = test_deref_immut_ref(&o);
        let r5 = test_deref_mut_ref(&mut o);
        let r6 = test_combined_field_deref(&mut o);
        let r7 = test_combined_index_deref(&o);
        let r8 = test_ref_holder(&mut o);
        (r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8)
    }
}



//# run 0xCAFE::IdDataAccessDeref::test_identifier_binding



//# run 0xCAFE::IdDataAccessDeref::create_outer



//# run 0xCAFE::IdDataAccessDeref::test_field_access --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::test_index_access --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::test_deref_immut_ref --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::test_deref_mut_ref --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::test_combined_field_deref --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::test_combined_index_deref --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::test_ref_holder --args 0xCAFE --signers 0xCAFE



//# run 0xCAFE::IdDataAccessDeref::runner
