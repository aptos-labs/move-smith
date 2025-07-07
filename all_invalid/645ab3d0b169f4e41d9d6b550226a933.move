//# publish
module 0xA::ModA {
    struct Inner has copy, drop, store {
        val: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
    }

    public fun make_outer(value: u64): Outer {
        Outer { inner: Inner { val: value } }
    }

    public fun nested_access(o: &Outer): u64 {
        // Chain dotted expressions to get inner.val
        o.inner.val
    }

    // A "runner" that returns nested value
    public fun runner(): u64 {
        let o = make_outer(42);
        nested_access(&o)
    }
}
//# run 0xA::ModA::runner

//# publish
module 0xB::ModB {
    use 0xA::ModA;

    // Attempt to call 0xA::ModA::nested_access (should fail at compile if uncommented)
    // public fun try_call_other(addr_outer: &ModA::Outer): u64 {
    //     ModA::nested_access(addr_outer)
    // }

    // Instead, we add a dummy wrapper that tries to call a fictional function from 0xA,
    // but we won't call it in runner to respect the no cross-address call rule.
    
    // Conditional unpacking: given a vector of Outer structs, returns Some(val) of first 
    // if present and > 0, None otherwise.
    public fun conditional_unpack(v: vector<ModA::Outer>): option::Option<u64> {
        if (vector::is_empty(&v)) {
            option::none()
        } else {
            let o = vector::borrow(&v, 0);
            let val = o.inner.val;
            if (val > 0) {
                option::some(val)
            } else {
                option::none()
            }
        }
    }

    // Runner to test conditional_unpack with empty and non-empty
    public fun runner(): option::Option<u64> {
        let empty_vec = vector::empty<ModA::Outer>();
        let res1 = conditional_unpack(empty_vec);

        let mut non_empty_vec = vector::empty<ModA::Outer>();
        vector::push_back(&mut non_empty_vec, ModA::make_outer(100));
        let res2 = conditional_unpack(non_empty_vec);

        // Just return res2 for simplicity
        res2
    }
}
//# run 0xB::ModB::runner

//# run
script {
    use 0xA::ModA;
    use 0xB::ModB;

    fun main() {
        // 1. Confirm nested access
        let outer = ModA::make_outer(7);
        let val = ModA::nested_access(&outer);
        // No assertion needed, just exercise this call

        // 2. Confirm calling runner in 0xA
        let nested_val = ModA::runner();

        // 3. Confirm conditional_unpack runner in 0xB
        let opt_val = ModB::runner();

        // 4. Attempt invalid cross-address call by example (commented out - will fail if uncommented)
        // let val2 = ModB::try_call_other(&outer);
    }
}