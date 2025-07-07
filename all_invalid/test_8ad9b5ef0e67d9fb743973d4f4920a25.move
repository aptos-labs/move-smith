//# publish
module 0x42::test_interaction {
    struct S has drop, copy {
        value: u64
    }

    fun eq_with<T: drop>(x: T): |T| bool {
        |y| x == y
    }

    //# publish
    module 0x42::helper {

        public fun get_value() {
            42u64
        }

        public fun generate_struct(val: u64): S {
            S { f: val }
        }

        public fun modify_struct(s: &mut S, new_val: u64) {
            s.f = new_val;
        }
    }

    // Test for u64 equality and custom struct equality
    public fun test_value_comparisons() {
        let check_u64 = eq_with(100);
        let result1 = check_u64(100);
        let result2 = check_u64(200);

        // Create structs for comparison
        let s1 = S { f: 42 };
        let s2 = S { f: 42 };
        let s3 = S { f: 7 };

        let eq_struct = eq_with(S { f: 42 });
        let result3 = eq_struct(s1);
        let result4 = eq_struct(s3);
    }

    // Test for variable shadowing inside a nested lambda
    public fun test_shadow_and_modify() {
        let _x = 5;
        //# run 0x42::helper::generate_struct --args 10
        let mut s = S { f: 0 };
        helper::modify_struct(&mut s, 20);
        assert!(_x == 5, 0);
        // Shadowing outer _x inside a lambda
        let _x = 10;
        foo_fn(|y: u64| {
            _x = y; // Should assign to lambda's _x, not outer
        });
        // After calling foo_fn, lambda's _x should be 42
        assert!(_x == 42, 0);
    }

    inline fun foo_fn(f: |u64|) {
        let _x = 42;
        f(_x);
    }
}

//# run 0x42::test_interaction::test_value_comparisons
//# run 0x42::test_interaction::test_shadow_and_modify