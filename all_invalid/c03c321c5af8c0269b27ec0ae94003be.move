// Aptos Move Transactional Test for:
// 1. Local variable reassignment.
// 2. Explicit module/script dependency ordering.
// 3. Shortest cyclic dependency detection.
// Addresses: 0xCAFE, 0xBEEF, 0xDEAD

//=======================================================
//# publish
module 0xCAFE::Utils {
    public fun double(x: u64): u64 {
        let y = x;
        y = y + x;
        y
    }

    public fun triple(x: u64): u64 {
        let result = x;
        let temp = result * 3;
        temp
    }

    public fun runner() {
        let a = 10;
        let b = double(a);
        let c = triple(b);

        // Variable reassignment sequence
        let x = 7u64;
        x = x + 1;
        x = x * 2;
        x = x - 4;
        x = x / 2;
        // final result is expected: (((7+1)*2)-4)/2 = 6u64
        let out = x + c;
        let _ = out; // Just to use the variables
    }
}
//# run 0xCAFE::Utils::runner --signers 0xCAFE

//=======================================================
// Utils dependency, and exposes a resource type.
//# publish
module 0xBEEF::Storage {
    use 0xCAFE::Utils;

    struct Counter { val: u64, }

    public fun init(s: &signer) {
        move_to<Counter>(s, Counter { val: 0 })
    }

    public fun inc(s: &signer) {
        let c = borrow_global_mut<Counter>(address_of(s));
        c.val = Utils::double(c.val) + 1;
    }

    public fun get(s: &signer): u64 {
        borrow_global<Counter>(address_of(s)).val
    }

    public fun destroy(s: &signer) {
        let _counter = move_from<Counter>(address_of(s));
    }

    public fun runner(s: &signer) {
        init(s);
        inc(s);
        inc(s);
        let v = get(s);
        let _ = v;
        destroy(s);
    }
}
//# run 0xBEEF::Storage::runner --signers 0xBEEF

//=======================================================
// Example of shortest cyclic dependency.
// Module C imports B, B imports A, and A imports C, creating a cycle A->C->B->A
// This should fail to publish due to a cyclic dependency

//# publish
module 0xDEAD::A {
    use 0xDEAD::C; // <-- Intends to create cycle
    public fun hi(): u8 { C::bye() }
}

//# publish
module 0xDEAD::B {
    use 0xDEAD::A;
    public fun yo(): u8 { A::hi() }
}

//# publish
module 0xDEAD::C {
    use 0xDEAD::B;
    public fun bye(): u8 { B::yo() }
}

// Above, publishing order is given: A, B, C, but because
//   A depends on C, which depends on B, which depends on A, 
//   Move should detect a cycle (A->C->B->A) and reject it.

// The above modules test dependency cycle error

// Featurres:
// e0647ae03f52e75fb33319a40b3832e9: Verify that local variables can be reassigned within the same function.
// e3676f72aa3a1a51b1f06fb585eb13ab: Define modules and scripts with explicit dependency orderings.
// b87d274b57a078e136b459f4ce173e13: Detect shortest cyclic dependencies among Move modules or scripts
