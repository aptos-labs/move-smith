
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
    public fun deprecated_function(): u8 {
        0xff
    }

    // Module marked as deprecated, just for warning check
    // deprecated]
//# publish
    module 0xDEAD::DeprecatedModule {
        public fun old_feature(): u8 {
            1
        }
    }

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


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 390b5dabfa1eded9d6a07449255a295e: Mark entire modules as deprecated with an annotation.
// 74665b166542421d38b99e7f0be094fb: Use the `require_move_2_and_advance` function to check for the presence of the 'move_2' feature in your code.
