
//# publish
module 0xDEAD::TestNestedFields {
    use std::vector;

    struct Outer has store, key {
        inner: Inner,
        other: u64,
    }

    struct Inner has store, key {
        deep: Deep,
        value: bool,
    }

    struct Deep has store, key {
        data: u128,
    }

    public fun create_outer(): Outer {
        let deep = Deep { data: 42 };
        let inner = Inner { deep, value: true };
        Outer { inner, other: 100 }
    }

    public fun test_nested_access(): u128 {
        let outer = create_outer();
        let deep_data = outer.inner.deep.data;
        deep_data
    }

    public fun local_var_scoping_test() {
        let x = 10;
        while (x < 20) {
            let y = x + 1;
            // shadow previous x in inner scope
            let x = y;
            let _ = x; // just to use x
        };
        // outside loop, x should still be 10, but since shadowed, original x remains unchanged
    }

    public fun variable_shadowing_inside_loop(): u64 {
        let a = 5u64;
        let b = a;
        let i = 0;
        while (i < 3) {
            let b = b + i;
            let _ = b;
            i = i + 1;
        };
        b
    }

    // Internal function, should be called only within module
    internal fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun call_internal_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }

    // Spec function with purity and correctness checks
    public fun pre_post_spec(x: u64): u64
        ensures result >= x
        pure
    {
        x + 1
    }

    // Function currying with closures
    public fun curry_add(a: u8): |u8|u8 {
        |b: u8| a + b
    }

    public fun test_currying(): u8 {
        let add_three = curry_add(3);
        let result = add_three(4);
        result
    }

    
//# deprecated
    // Mark entire module as deprecated
    // (Note: In Move, there's no explicit 'deprecated' attribute on modules as of now,
    //  but for testing purposes, assume a custom annotation or comment.)
    // deprecated]
    // Note: The previous malformed comment/annotation was removed to prevent parse errors

    // Test for feature flag move_2 and advance
    public fun require_move_2_and_advance(): bool {
        move_2
        // assume move_2 is a feature flag check
        true
    }
}


//# run 0xDEAD::TestNestedFields::test_nested_access


//# run 0xDEAD::TestNestedFields::variable_shadowing_inside_loop


//# run 0xDEAD::TestNestedFields::call_internal_add --args 10u64 20u64


//# run 0xDEAD::TestNestedFields::test_currying


//# run 0xDEAD::TestNestedFields::require_move_2_and_advance
