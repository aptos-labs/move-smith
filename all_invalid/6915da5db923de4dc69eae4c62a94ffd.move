//# publish
module 0xCAFE::TestTupleAndDestructuring {
    struct S {
        x: u64,
        y: u64,
        z: u64,
    }

    public fun runner() {
        let (a, (b, c)) = (1u64, (2u64, 3u64));
        // dummy usage to bind variables
        let _ = a + b + c;

        let s = S { x: 10, y: 20, z: 30 };
        // Destructuring assignment with struct pattern, binding order test
        let S { x, y, z } = s;
        let _ = x + y + z;
    }
}

//# publish
module 0xCAFE::MutableRefReturn {
    public fun return_same_mut_ref(r: &mut u64): &mut u64 {
        *r = *r + 1;
        r
    }

    public fun runner() {
        let mut local = 100u64;
        // borrow a mutable ref and call function returning same mutable ref
        let r = &mut local;
        let r2 = return_same_mut_ref(r);
        *r2 = *r2 + 2;

        // ensure shared immut ref to local is valid after mutable func call
        let s = &local;
        let _ = *s;
    }
}

//# publish
module 0xCAFE::NestedAccess {
    struct Outer {
        inner: Inner,
        count: u64,
    }

    struct Inner {
        val: u64,
    }

    public fun new_outer(): Outer {
        Outer {
            inner: Inner { val: 999 },
            count: 42,
        }
    }

    public fun get_inner_val(o: &Outer): u64 {
        o.inner.val
    }

    public fun runner() {
        let o = new_outer();
        let val = o.inner.val;
        let count = o.count;
        let val2 = get_inner_val(&o);

        let _ = val + count + val2;
    }
}

//# run 0xCAFE::TestTupleAndDestructuring::runner

//# run 0xCAFE::MutableRefReturn::runner

//# run 0xCAFE::NestedAccess::runner

// Featurres:
// a4b3cc025165969ecdb1d77431e80679: Test tuple pattern matching and variable binding order in struct destructuring assignments.
// f5ff2773cd04e0ee5606328039fee0b0: Test that the function accepts a mutable reference, returns the same mutable reference, and that a shared immutable reference to a local variable is valid.
// 323360c04f0fd067745b2d3cb5106e5e: Access nested fields or methods using dotted expressions in Move code
