
//# publish
module 0xCAFE::BinaryValidation {
    /// Dummy struct for testing ability constraints
    struct C has copy {}
    struct D has drop {}
    struct S has store {}

    /// A function to demonstrate abiding by ability constraints
    public fun use_abilities<T: copy + drop + store>(_x: T) {
        // empty body, only to enforce constraints at compile time
    }

    /// A struct with generic constrained types
    struct GenericWithConstraints<T: copy, U: drop, V: store> has store {
        t_field: T,
        u_field: U,
        v_field: V,
    }

    /// A function to create an instance of GenericWithConstraints
    public fun create_generic_instance<T: copy, U: drop, V: store>(
        t: T,
        u: U,
        v: V
    ): GenericWithConstraints<T, U, V> {
        GenericWithConstraints<T, U, V> {
            t_field: t,
            u_field: u,
            v_field: v,
        }
    }

    /// Runner function to call use_abilities with a type satisfying all constraints
    public fun runner() {
        let c = C {};
        use_abilities<C>(c);
    }
}


//# run 0xCAFE::BinaryValidation::runner


// Note: The following code is to simulate "binary" validation and experimental
// feature flag tests as comments and mock logic, because the Move language and
// Aptos framework do not allow direct access to environment variables or binary
// file loading in Move code. These tests must be done in transaction tests or
// external frameworks, so here we show the right structure in the test file.

/*
Test Plan for Experimental Features:

// 1. Experimental Features enabling test (conceptual, no real env var access in Move):
//    Set environment variables:
//    export MVC_EXP="feature1,feature2"
//    export MOVE_COMPILER_EXP="featureA,featureB"
//    Compile a module with experimental syntax (e.g., new ability constraints or syntax).

// 2. Compile a module with constrained generic types and experimental features enabled.

// 3. Validate the compiled binary contains the MODULE_MAGIC number 0xCADE
//    This can be done by binary inspection in external tests.

// 4. Compile a module that violates constraints and confirm compiler errors (negative test).

// 5. Compile a module with no experimental features enabled and confirm conservative behavior.

// These steps require external scripts and are outside the Move code transactional tests.

*/


//# publish
module 0xCAFE::ExpFeatureTest {
    /// Simulating experimental features controlled module
    struct E has copy, drop, store {}

    public fun experimental_func<T: copy + drop>(_val: T) {
        // Dummy function simulating experimental feature requiring both copy and drop
    }

    /// Runner creating an instance and calling experimental_func
    public fun run_exp() {
        let e = E {};
        experimental_func<E>(e);
    }
}


//# run 0xCAFE::ExpFeatureTest::run_exp



//# publish
module 0xCAFE::CombinedTest {
    use 0xCAFE::BinaryValidation;
    use 0xCAFE::ExpFeatureTest;

    struct Combined<T: copy + drop, U: store> has store {
        t_field: T,
        u_field: U,
    }

    public fun combined_runner() {
        // Compose instances from other modules exercising constraints
        let c = BinaryValidation::C {};
        let d = BinaryValidation::D {};
        let s = BinaryValidation::S {};
        let generic = BinaryValidation::create_generic_instance<BinaryValidation::C, BinaryValidation::D, BinaryValidation::S>(c, d, s);

        ExpFeatureTest::experimental_func<BinaryValidation::C>(c);

        let combined = Combined<BinaryValidation::C, BinaryValidation::S> {
            t_field: c,
            u_field: s,
        };

        let _ = generic;
        let _ = combined;
    }
}


//# run 0xCAFE::CombinedTest::combined_runner


// Featurres:
// 0570ad80826f2d2b88ce4fcf68107ff6: Check for the presence of the Move module magic number in a binary file
// 1f1e15d73a91ef2d9e16f4165568f8a3: Include ability constraints in type parameter declarations to enforce capabilities.
// 0d8ec7631103f529e4bcd291dfa33ff7: Enable experimental compiler features by specifying them as a comma-separated list in the MVC_EXP or MOVE_COMPILER_EXP environment variables.
