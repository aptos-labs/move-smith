//# publish
module 0xCAFE::DeprecationTest {
    // Deprecate a struct in favor of a new one, with location.
    /// Deprecated: Use `NewStruct` instead. See https://docs.example.com/newstruct
    #[deprecated(since = 1, note = "Use `NewStruct` instead. See https://docs.example.com/newstruct")]
    struct OldStruct has copy, drop {
        x: u64,
    }

    struct NewStruct has copy, drop {
        x: u64,
    }

    /// Deprecated: Please use `new_add_one` instead. See https://docs.example.com/new_add_one
    #[deprecated(
        since = 1,
        note = "Please use `new_add_one` instead. See https://docs.example.com/new_add_one"
    )]
    public fun add_one_deprecated(x: u64): u64 {
        x + 1
    }

    spec add_one_deprecated {
        ensures result == x + 1;
    }

    public fun new_add_one(x: u64): u64 {
        x + 1
    }

    // Deprecate a field in a struct.
    struct Compound has copy, drop {
        /// Deprecated: field_a is replaced by field_b. See https://docs.example.com/compound
        #[deprecated(
            since = 1,
            note = "field_a is replaced by field_b. See https://docs.example.com/compound"
        )]
        field_a: u8,
        field_b: u8,
    }

    spec new_add_one {
        ensures result == x + 1;
    }

    // Deprecate a function parameter.
    public fun function_with_deprecated_param(
        #[deprecated(since = 1, note = "y will be removed in v2, see https://docs.example.com/remove-y")]
        y: u64,
        z: u64
    ): u64 {
        y + z
    }

    spec function_with_deprecated_param {
        ensures result == y + z;
    }

    // A runner function to trigger deprecated calls
    public fun run_deprecation() {
        let v1 = Self::add_one_deprecated(41);
        let v2 = Self::new_add_one(42);
        let c = Compound { field_a: 3, field_b: 4 };
        let _ = Self::function_with_deprecated_param(10, 20);
        let _ = Self::OldStruct { x: 123 };
        let _ = Self::NewStruct { x: 456 };
    }
}
//# run 0xCAFE::DeprecationTest::run_deprecation

// ---------------------------------------------------------

//# publish
module 0xCAFE::ClosureNest {
    // Demonstrate nested closure capture and composition.

    // A function that returns a closure capturing its argument.
    public fun make_adder(x: u64): fun(u64): u64 {
        fun(y: u64): u64 { x + y }
    }

    // A function that takes two closures, and returns a composed closure.
    public fun compose(
        f: fun(u64): u64,
        g: fun(u64): u64
    ): fun(u64): u64 {
        fun(a: u64): u64 { f(g(a)) }
    }

    // A runner function that demonstrates
    // - nested closures capturing at different scopes
    // - returning closures
    // - composing closures
    public fun run_nest() {
        let y = 7;
        let add_y = fun(a: u64): u64 { a + y };
        let mul_two = fun(b: u64): u64 { b * 2 };

        // Compose mul_two then add_y: (a) => (a*2) + y
        let composed = Self::compose(add_y, mul_two);
        let res1 = composed(10); // (10*2) + 7 = 27

        // Closure returned from make_adder, partially applied
        let add_100 = Self::make_adder(100);
        let res2 = add_100(50); // 150

        // Closure in a closure: nested
        let closure = fun(p: u64): fun(u64): u64 {
            let local = 5;
            fun(q: u64): u64 {
                p * q + local // p captured from outer, local from this scope
            }
        };
        let times_add5 = closure(4); // (q: u64) => 4*q + 5
        let res3 = times_add5(3); // 12 + 5 = 17

        let _ = (res1, res2, res3);
    }
}
//# run 0xCAFE::ClosureNest::run_nest

// ---------------------------------------------------------

//# publish
module 0xCAFE::PureSpecTest {
    // Function that has no side effects, should be pure.
    public fun pure_add(x: u64, y: u64): u64 {
        x + y
    }
    spec pure_add {
        ensures result == x + y;
        // This should pass pureness checking (no side effect instructions).
    }

    // Function with side effect (write to global), not pure.
    struct Counter has key { val: u64 }

    public fun impure_add_and_store(account: &signer, v: u64) {
        move_to(account, Counter { val: v });
    }

    spec impure_add_and_store {
        // Cannot mark as pure, since it has side effects.
        // Just simple ensures.
        aborts_if false;
    }

    // A runner to call both
    public fun run_spec(account: &signer) {
        let _ = Self::pure_add(10, 32);
        Self::impure_add_and_store(account, 99);
    }
}
//# run 0xCAFE::PureSpecTest::run_spec --signers 0xCAFE

// Featurres:
// 97131cde6532fb2fa480d1cd8fcf9daf: Deprecate specific items in a Move module and provide a location for the deprecation, so users know where and why an item is deprecated.
// c0b603c0378f40d20cbf5caeed8e8ac7: Test that nested closure functions can capture variables at different scopes and be composed, including returning closures from functions and composing them with other closures.
// 1f4728289abd8ba779d797141e517192: Write specifications for Move functions to enable pureness checking.
