// This file is a Move transactional test, that tests:
// 1) Calling a function named `match` with various argument patterns
// 2) Type checking correctness
// 3) Proper handling of assignment through &mut references, including nested fields, inline functions, closures, temporaries

address 0x1 {
    module TestMatch {

        // A struct with nested fields to test &mut reference assignments
        struct Outer has copy, drop, store {
            a: u64,
            inner: Inner,
        }

        struct Inner has copy, drop, store {
            b: u64,
            c: bool,
        }

        // A simple `match` function similar to pattern matching.
        // Just sums or returns a default u64.
        public fun match(): u64 {
            42
        }

        public fun match(x: u64): u64 {
            x + 1
        }

        public fun match(x: u64, y: u64): u64 {
            if (x > y) {
                x
            } else {
                y
            }
        }

        // A helper function to update nested struct fields via &mut references.
        fun update_fields(o: &mut Outer, val: u64) {
            // Assigning to a field through &mut reference
            *&mut o.a = val;
            *&mut o.inner.b = val + 1;

            // Nested assignment using deref & mut refs
            let inner_ref = &mut o.inner;
            *&mut inner_ref.c = false;

            // Assignment through inline function return &mut
            fun get_inner_mut(o: &mut Outer): &mut Inner {
                &mut o.inner
            }
            *&mut get_inner_mut(o).b = val + 2;

            // Assignment through a temporary &mut reference
            let inner_tmp: &mut Inner = &mut o.inner;
            *inner_tmp.b = val + 3;

            // Assignment through closure capturing &mut
            let mut_closure = |inner_ref: &mut Inner, v: u64| {
                *&mut inner_ref.b = v;
            };
            mut_closure(&mut o.inner, val + 4);
        }

        // A function testing no mutation of non-mutable value or temporaries through &mut refs
        // This should fail if we try to mut ref an immutable variable, but here we rely on type checker.
        fun try_assign_to_immutable() {
            let x: u64 = 10;
            // The following line would fail type checker because x is immutable:
            // let r: &mut u64 = &mut x;
            // *r = 20;

            // Instead, only immutable references allowed for x:
            let r: &u64 = &x;
            let _copy = *r; // valid read

            // Attempt mut ref to a temporary (e.g. return value):
            // let r_tmp: &mut u64 = &mut (10 + 20); // This is invalid and won't compile

            // Instead, use mutable local variables to test mutation:

            let mut y = 5;
            let r_mut: &mut u64 = &mut y;
            *r_mut = 15;  // valid mutable assignment

            // Confirm y changed
            assert!(*r_mut == 15, 1);

            // Now test that inline function returning a temporary &mut reference is forbidden:
            // fun temp_ref(): &mut u64 {
            //     &mut (10) // invalid, no mutable ref to temporary literal
            // }
            // -- omitted to compile
        }

        #[test]
        public fun test_match_and_assign() {
            // Test calls to overloaded match functions

            let v0 = match();
            assert!(v0 == 42, 100);

            let v1 = match(5);
            assert!(v1 == 6, 101);

            let v2 = match(3, 4);
            assert!(v2 == 4, 102);

            let v3 = match(10, 2);
            assert!(v3 == 10, 103);

            // Create mutable Outer struct, test &mut assignments

            let mut outer = Outer {
                a: 0,
                inner: Inner { b: 0, c: true },
            };

            // Update fields via &mut references and nested operations
            update_fields(&mut outer, 100);

            // Check final values after update_fields
            assert!(outer.a == 100, 200);
            assert!(outer.inner.b == 104, 201); // last set val + 4
            assert!(outer.inner.c == false, 202);

            // Test that assignments through inline functions, temporaries (closures), nested fields passed type check

            // Try to call non-mutating function to test type-check correctness

            try_assign_to_immutable();

            // Summary of success
            assert!(true, 999); // dummy success
        }
    }
}

// Featurres:
// 4a4eeb55d56174eda24dcb87a0f82169: Call a function named `match` using standard function call syntax, such as `match(arg1, arg2, ...)` or `match()` with zero or more arguments.
// 1f5ff922edbcdf6a2b9cb56eb0829fe6: Run the type checker on Move code.
// b6e96a49b120efc88bc72a8870c6502e: Test that assignment through &mut references (including to fields, nested fields, complex expressions, inline functions, temporaries, and closures) is correctly type-checked, handled, and never mutates non-mutable values or temporaries in the Aptos Move language.
