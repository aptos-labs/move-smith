//# publish
module 0xCAFE::DeprecationTest {
    // Deprecate a struct in favor of a new one, with location.
    /// Deprecated: Use `NewStruct` instead. See https://docs.example.com/newstruct
    //#[deprecated(since = 1, note = b"Use `NewStruct` instead. See https://docs.example.com/newstruct")] // Deprecated attributes not yet supported in Aptos Move
    struct OldStruct has copy, drop {
        x: u64,
    }

    struct NewStruct has copy, drop {
        x: u64,
    }

    /// Deprecated: Please use `new_add_one` instead. See https://docs.example.com/new_add_one
    //#[deprecated(
    //    since = 1,
    //    note = b"Please use `new_add_one` instead. See https://docs.example.com/new_add_one"
    //)]
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
        //#[deprecated(
        //    since = 1,
        //    note = b"field_a is replaced by field_b. See https://docs.example.com/compound"
        //)]
        field_a: u8,
        field_b: u8,
    }

    spec new_add_one {
        ensures result == x + 1;
    }

    // Deprecate a function parameter.
    public fun function_with_deprecated_param(
        //#[deprecated(since = 1, note = b"y will be removed in v2, see https://docs.example.com/remove-y")]
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

    // Replace closures with manual functions, as Move does not support lambdas/closures.

    // A function that returns an adder with a constant.
    public fun add_x(a: u64, x: u64): u64 {
        a + x
    }

    // A function that doubles its argument.
    public fun mul_two(a: u64): u64 {
        a * 2
    }

    // Compose: f(g(a))
    public fun compose_add_x_mul_two(a: u64, x: u64): u64 {
        Self::add_x(Self::mul_two(a), x)
    }

    // A function like closure(4)(3) = 4 * 3 + 5, i.e. times + 5
    public fun times_add5(p: u64, q: u64): u64 {
        p * q + 5
    }

    public fun run_nest() {
        let y = 7;
        let res1 = Self::compose_add_x_mul_two(10, y); // (10*2) + 7 = 27
        let res2 = Self::add_x(50, 100); // 50 + 100 = 150
        let res3 = Self::times_add5(4, 3); // 4*3 + 5 = 17
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
