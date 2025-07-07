//# publish
module 0x42::ClosureParamTest {
    // Inline function accepting a closure with a single parameter
    inline fun apply_closure(f: |u64| u64, value: u64): u64 {
        f(value)
    }

    // Inline function accepting a closure with multiple parameters
    inline fun apply_multi_closure(
        f: |u64, u64| u64,
        x: u64,
        y: u64
    ): u64 {
        f(x, y)
    }

    // Inline function accepting a closure with mixed parameter types and explicit pattern matching
    inline fun apply_pattern_closure(
        f: |{a: u64, b: u64}| u64,
        pair: {a: u64, b: u64}
    ): u64 {
        f(pair)
    }

    public fun test_closure_params() {
        let r1 = apply_closure(|x| x * 2, 5);
        let r2 = apply_multi_closure(|x, y| x + y, 10, 20);
        let r3 = apply_pattern_closure(|pair| pair.a * pair.b, {a: 3, b: 4});
        // No assertions needed, just for VM execution
    }

    // Function to test closure with different parameter configurations
    public fun test() {
        test_closure_params();
    }
}

//# run 0x42::ClosureParamTest::test

//# publish
module 0x42::ClosureInteractionTest {
    // Inline function that accepts a closure modifying two u64 parameters
    inline fun compute_with_closure(
        f: |mut u64, mut u64| u64,
        a: u64,
        b: u64
    ): u64 {
        f(&mut a, &mut b)
    }

    // Runner function that calls a closure which multiplies first param, adds second
    public fun run_test() {
        let result = compute_with_closure(
            |a: &mut u64, b: &mut u64| {
                *a = *a * 2;
                *b = *b + 3;
                *a + *b
            },
            4,
            5
        );
        // Expected: (4*2) + (5+3) = 8 + 8 = 16
    }
}

//# run 0x42::ClosureInteractionTest::run_test

//# publish
module 0x42::VariantMatchingTest {
    struct S0 has drop {}

    struct S1<A, B> has drop {
        x: A,
        y: B
    }

    enum E has drop {
        V1{ x: u8, y: S1<u8, bool>},
        V2 {
            x: u8,
            y: S0
        }
    }

    fun extract_u8_from_e(e: &E): u8 {
        match (e) {
            E::V1{ x, y: S1 { x: inner_x, y: _ } } => *x,
            E::V2 { y: _, x: _ } => 42,
        }
    }

    public fun test() {
        let value1 = E::V1 { x: 7, y: S1 { x: 1, y: false } };
        let value2 = E::V2 { x: 8, y: S0 {} };
        let r1 = extract_u8_from_e(&value1);
        let r2 = extract_u8_from_e(&value2);
        // No assertions, just compile and run
    }
}

//# run 0x42::VariantMatchingTest::test

//# publish
module 0x42::NestedFunctionCallTest {
    public inline fun inner_x(x: u64): u64 {
        x + 100
    }

    public inline fun inner_y(y: u64): u64 {
        y * 2
    }

    public fun combined_fun() : u64 {
        inner_x(inner_y(5))
    }
}

//# run 0x42::NestedFunctionCallTest::combined_fun