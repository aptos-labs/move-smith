// MODULE: Spec and Nested Functions Transactional Test

//============================== MODULE 1 ==============================

//# publish
module 0xA1::SpecTest {
    use std::vector;
    use std::signer;

    #[test_only]
    struct MyStruct has copy, drop, store {
        x: u64,
        y: u8,
    }
    spec MyStruct {
        // Invariant: x must always be greater than 0
        invariant self.x > 0;
    }


    public fun new_my_struct(x: u64, y: u8): MyStruct acquires MyStruct {
        // Spec: precondition & postcondition
        spec {
            requires x > 0;
            ensures result.x == x && result.y == y;
        }
        MyStruct {x, y}
    }

    public fun inc_struct(mut s: &mut MyStruct, delta: u64) {
        // Spec: delta must be positive, x increases by delta
        spec {
            requires delta > 0;
            ensures s.x == old(s.x) + delta;
        }
        s.x = s.x + delta;
    }

    public fun test_invariant(): MyStruct {
        let s = new_my_struct(10, 4);
        s
    }

    public fun runner() {
        let mut s = new_my_struct(8, 1);
        inc_struct(&mut s, 3);
        inc_struct(&mut s, 4);
    }
}
//# run 0xA1::SpecTest::runner --signers 0xA1

//============================== MODULE 2 ==============================

//# publish
address 0xB2 {
module HigherOrderAndUse {
    use std::vector;

    public fun add(a: u64, b: u64): u64 {
        spec {
            ensures result == a + b;
        }
        a + b
    }

    public fun apply_twice(f: &fn(u64, u64): u64, x: u64, y: u64): u64 {
        // Calls f(f(x, y), y)
        f(f(x, y), y)
    }

    public fun mk_adder(z: u64): fn(u64, u64): u64 {
        // Returns a closure that adds a fixed constant 'z' to sum
        fun inner(x: u64, y: u64): u64 { x + y + z }
        inner
    }

    public fun higher_order_demo(): u64 {
        let f: fn(u64, u64): u64 = add;
        apply_twice(&f, 3, 4) // should compute add(add(3,4),4) = add(7,4) = 11
    }

    public fun closure_demo(): u64 {
        let adder = mk_adder(5);
        adder(10, 2) // Should return 10 + 2 + 5 = 17
    }

    public fun nested_closures(): u64 {
        // Returns a closure of a closure and invokes it
        fun make_inner(mult: u64): fn(u64): u64 {
            fun inner(x: u64): u64 { x * mult }
            inner
        }
        let f = make_inner(7);
        f(6) // 6*7=42
    }

    public fun runner() {
        let x = higher_order_demo();
        let y = closure_demo();
        let z = nested_closures();
        // For debugging
        vector::empty<u64>();
        // (can place values in result vector or simply exercise the code paths)
    }
}
}
//# run 0xB2::HigherOrderAndUse::runner --signers 0xB2

//============================== SCRIPT SECTION ==============================

//# run
script {
    use 0xA1::SpecTest;
    public fun main(account: &signer) {
        let s = SpecTest::test_invariant();
        // Struct invariant and specs exercised
        // Can do further calls if needed
    }
}

//# run
script {
    use 0xB2::HigherOrderAndUse;
    public fun main(_account: &signer) {
        // Test closure/HO function
        let r1 = HigherOrderAndUse::higher_order_demo();
        let r2 = HigherOrderAndUse::closure_demo();
        let r3 = HigherOrderAndUse::nested_closures();
        // Values are on stack; just to run
    }
}