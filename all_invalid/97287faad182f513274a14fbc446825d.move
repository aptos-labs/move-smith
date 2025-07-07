//# publish
module 0xCAFE::MyStructs {
    // Import standard library modules as explicit dependencies
    use std::vector;
    use std::cmp;

    // A struct with two fields
    struct Pair has copy, drop {
        a: u8,
        b: u64,
    }

    // Another struct to test dot access and methods
    struct Wrap has copy, drop {
        inner: u8,
    }

    // Expose Pair and a factory for it
    public fun make_pair(a: u8, b: u64): Pair {
        Pair { a, b }
    }

    public fun get_a(pair: &Pair): u8 {
        pair.a
    }

    public fun get_b(pair: &Pair): u64 {
        pair.b
    }

    // Expose Wrap and a method
    public fun make_wrap(x: u8): Wrap {
        Wrap { inner: x }
    }

    public fun inc(w: &mut Wrap) {
        w.inner = w.inner + 1;
    }

    // Runner to be called from transaction (for test case)
    public fun runner() {
        let p = Pair { a: 3, b: 1000 };
        let a = p.a;
        let b = p.b;
        let mut w = Wrap { inner: 42 };
        Self::inc(&mut w);
        // Will now be 43
        let y = w.inner;
        // Use vector as an explicit dependency
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, a);
        vector::push_back(&mut v, y);
        // Use cmp as an explicit dependency
        let eq: bool = cmp::eq<u8>(v[0], v[1]);
        // No assertion, just an explicit test of field access, method access, vector, cmp
        let _ = eq;
    }
}
//# run 0xCAFE::MyStructs::runner --signers 0xCAFE

//# publish
module 0xCAFE::UseMembers {
    use std::vector;
    use std::cmp;
    // Importing specific members with optional aliases
    use 0xCAFE::MyStructs::{Pair, make_pair as mkp, get_b};

    public fun runner() {
        // mk_pair uses alias
        let p = mkp(7, 9999);
        // Direct dot access to struct fields
        let aa = p.a;
        let bb = p.b;
        // Use other imported member
        let bb2 = get_b(&p);
        // Vector usage as an explicit dependency
        let v = vector::singleton(aa);
        let _ = v;
        // Use cmp as an explicit dependency
        let r = cmp::ne<u64>(bb, bb2);
        let _ = r;
    }
}
//# run 0xCAFE::UseMembers::runner --signers 0xCAFE

//# run
script {
    use std::vector;
    use std::cmp;
    // Import specific members from the previous module
    use 0xCAFE::MyStructs::{Pair, make_pair, get_a, get_b};
    // Import specific members using an alias
    use 0xCAFE::MyStructs::{make_wrap as new_wrap};

    fun main() {
        let p = make_pair(5, 555);
        // Use dot access
        let aa = p.a;
        let bb = p.b;
        // Call imported getters for struct fields
        let a2 = get_a(&p);
        let b2 = get_b(&p);

        // Use an alias for a function import
        let w = new_wrap(99);

        // Use explicit dependency on vector
        let v = vector::singleton(a2);

        // Use cmp as explicit dependency (equality test)
        let x = cmp::eq<u8>(aa, v[0]);
        let _ = x;
        let y = cmp::eq<u64>(bb, b2);
        let _ = y;
    }
}

// Featurres:
// 7f06a6ddd1a6fd0080a3c81aa0d71531: Refer to standard modules (such as 'vector' and 'cmp') as explicit dependencies in `std::<module>`.
// e3b75d75b043a543f9b015c19d7f6435: Use dot access to access fields or methods with `e.f`.
// 6027537863a2e7c5e74d6c3d82e94650: Import specific members of a module enclosed in braces with optional aliases