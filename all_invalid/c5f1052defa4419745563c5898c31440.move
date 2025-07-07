//# publish
address 0xCAFE {
    module SpecA {
        use std::marker;

        // Phantom type parameter parameter usage
        struct PhantomPhantomType<T> has copy, store {}

        // Spec module to represent a spec for some resource R
        spec module {
            struct Spec<R> has store {
                phantom: marker::PhantomData<R>,
            }

            // Mergeable spec example
            spec fun base_spec<R>() {}
        }

        // Runner function for tests
        public fun runner() {}
    }
}

//# publish
address 0xCAFE {
    module SpecB {
        use std::marker;

        spec module {
            struct Spec<S, T> has store {
                phantom1: marker::PhantomData<S>,
                phantom2: marker::PhantomData<T>,
            }

            spec fun base_spec<S, T>() {}

            spec fun some_ability_bound_fun<R: key + store + copy>() {}
        }

        public fun runner() {}
    }
}

//# publish
address 0xCAFE {
    module SpecCollection {
        use std::marker;

        // Merge three specs - simulate merging
        struct AllSpecs<R, S, T> has store {
            spec_1: SpecA::Spec<R>,
            spec_2: SpecB::Spec<S, T>,
            marker: marker::PhantomData<u8>,
        }

        // Spec module to centralize the management of multiple specs
        spec module {
            struct AllSpecs<R, S, T> has store {}

            spec fun merged_spec<R, S, T>() {}
        }

        public fun runner() {}
    }
}

//# publish
address 0xCAFE {
    module AbilityConstraints {
        // A function with ability constraints on type parameters.
        public fun with_ability_constraints<R: store + key + copy>() {}
        public fun runner() {
            // Call with_ability_constraints with R = u8 should work because u8 has key, store, and copy.
            with_ability_constraints<u8>();
        }
    }
}

//# run
script {
    use 0xCAFE::SpecA;
    use 0xCAFE::SpecB;
    use 0xCAFE::SpecCollection;
    use 0xCAFE::AbilityConstraints;

    fun main() {
        SpecA::runner();
        SpecB::runner();
        SpecCollection::runner();
        AbilityConstraints::runner();
    }
}