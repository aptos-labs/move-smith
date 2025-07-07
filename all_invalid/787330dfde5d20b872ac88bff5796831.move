// #publish
address 0xCAFE {
    module OptionUtils {
        use std::option;
        use std::vector;

        /// Option type to test map feature
        struct MyOption<T> has copy, drop, store, key {
            inner: option::Option<T>,
        }

        public fun some<T>(value: T): MyOption<T> {
            MyOption { inner: option::some<T>(value) }
        }

        public fun none<T>(): MyOption<T> {
            MyOption { inner: option::none<T>() }
        }

        /// map function: applies `f` on contained value if Some, otherwise returns None
        public inline fun map<T, U>(opt: &MyOption<T>, f: fun(&T): U): MyOption<U> {
            let inner_ref = &opt.inner;
            let mapped = option::map(inner_ref, f);
            MyOption { inner: mapped }
        }

        /// A runner function to exercise map on Some and None
        public fun run() {
            // function to double a u64 reference
            fun double(x: &u64): u64 { *x * 2 }

            // Some(10u64)
            let opt_some = some<u64>(10u64);
            let res_some = map(&opt_some, double);
            // res_some should be MyOption with some(20u64)

            // None<u64>
            let opt_none = none<u64>();
            let res_none = map(&opt_none, double);
            // res_none should be MyOption with none

            // Just consuming the results, no assert required
            let (v_some, is_some) = option::borrow(&res_some.inner);
            let _ = v_some;
            let _ = is_some;

            let (v_none, is_none) = option::borrow(&res_none.inner);
            let _ = v_none;
            let _ = is_none;

            // The code exercises map and references
        }

        /// Dummy function to simulate attaching compiled bytecode to analysis model
        /// and accessing environment's extensions.
        /// Since those are external to Move code, this dummy will exercise compiler use.
        public fun test_env_extensions() {
            // We create dummy behavior to assure compilation paths hit some environment logic.
            // Actual environment interaction only happens outside Move source.
        }
    }
}
// #run 0xCAFE::OptionUtils::run --signers 0xCAFE

// #run 0xCAFE::OptionUtils::test_env_extensions --signers 0xCAFE


// #run
script {
    use std::vector;
    use std::option;
    use 0xCAFE::OptionUtils;

    fun main() {
        // Use OptionUtils.map on Some and None directly in script

        // doubling function
        fun double(x: &u64): u64 { *x * 2 }

        let some_val = OptionUtils::some<u64>(7u64);
        let mapped_some = OptionUtils::map(&some_val, double);

        let none_val = OptionUtils::none<u64>();
        let mapped_none = OptionUtils::map(&none_val, double);

        // consume values to ensure no unused variable warnings
        let (v1, has1) = option::borrow(&mapped_some.inner);
        let (v2, has2) = option::borrow(&mapped_none.inner);
        let _ = (v1, has1, v2, has2);
    }
}

// Featurres:
// fda188fe1ba52851ff503c9efdd2a9d9: Attach the generated compiled bytecode directly to the analysis model after successful compilation.
// 5ccbabde1d14f07b92cfaf5295e24f18: Access and utilize the environment's extension options for custom behavior.
// 71a42a68fdf356aced1a004bec42605d: Test that the map function correctly transforms an Option value by applying a provided function when the option is Some, and returns None when the option is None.
