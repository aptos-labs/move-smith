//# publish
module 0xA1::destruct_example {
    struct Pair<T, U> {
        first: T,
        second: U,
    }

    fun compute_difference(x: u32, y: u32): u32 {
        let Pair(y, x) = Pair { first: x, second: y };
        y - x
    }

    public fun test_diff() {
        assert!(compute_difference(10, 4) == -6, 42);
    }
}

//# run --verbose -- 0xA1::destruct_example::test_diff

//# publish
module 0xA2::shadow_test {
    public inline fun apply_closure(f:|i64|, val: i64) {
        f(val);
    }

    public inline fun apply_closure_shadow(f:|i64|, val: i64) {
        let val = val;
        f(val);
    }

    public fun test_shadowing() {
        let mut outer_x: i64 = 1;
        apply_closure(|y: i64| {
            outer_x = y; // Should update outer_x to 3
        }, 3);
        assert!(outer_x == 3, 42);

        apply_closure_shadow(|z: i64| {
            outer_x = z; // Should update outer_x to 5
        }, 5);
        assert!(outer_x == 5, 42);
    }

    public fun test_shadowing_var() {
        let var_x: i64 = 10;
        apply_closure(|y: i64| {
            // Shadow inner, but outer var_x remains unchanged
            let var_x = y;
        }, 20);
        assert!(var_x == 10, 42);
        // Now with shadowing inside the closure
        apply_closure_shadow(|y: i64| {
            let var_x = y; // shadowed, does not affect outer var_x
        }, 30);
        assert!(var_x == 10, 42);
    }
}

//# run 0xA2::shadow_test::test_shadowing

//# publish
module 0xA3::init_serialization {
    use std::bcs;
    use std::string::{Self};
    use std::vector;

    const KEYS: vector<vector<u8>> = vector[
        vector[b"alpha"],
        vector[b"beta"],
        vector[b"gamma"]
    ];
    const VALUES: vector<u64> = vector[42, 100, 256];

    public entry fun init() {
        let utf8_keys = vector::map(KEYS, |k| { string::utf8(k) });
        let bytes_vals = vector::map(VALUES, |v| { bcs::to_bytes<u64>(&v) });
        // (No return, just process)
    }
}
//# run 0xA3::init_serialization::init