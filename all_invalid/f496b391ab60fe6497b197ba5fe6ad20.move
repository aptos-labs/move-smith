
//# publish
module 0xCAFE::BinaryValidation {
    /// Dummy struct for testing ability constraints
    // Updated C to have drop and store (required by use_abilities)
    struct C has copy, drop, store {}
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
