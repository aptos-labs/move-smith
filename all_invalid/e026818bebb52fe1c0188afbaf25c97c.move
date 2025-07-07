//# publish
#[deprecated]
address 0xCAFEDEAD {
    module Option {
        struct Option<T> has store {
            is_some: bool,
            value: T,
        }

        public fun some<T>(value: T): Option<T> {
            Option<T> {is_some: true, value}
        }

        public fun none<T>(): Option<T> {
            // We use dummy value for none variant, since Move does not have nullable types
            Option<T> {is_some: false, value: (Std::zero<T>())}
        }

        public fun is_some<T>(opt: &Option<T>): bool {
            opt.is_some
        }

        public fun unwrap<T>(opt: &Option<T>): &T {
            assert!(opt.is_some, 0);
            &opt.value
        }
    }

    #[specification]
    module Option {
        use 0x1::Std;

        spec fun is_some<T>(opt: &Option<T>): bool;

        spec fun map<T, U>(opt: &Option<T>, f: &fun(T): U): Option<U> {
            if (Option::is_some(opt)) {
                Option::some(f(*Option::unwrap(opt)))
            } else {
                Option::none()
            }
        }
    }
}

//# publish
module 0xCAFEDEAD::OptionUsage {
    use 0xCAFEDEAD::Option;

    public fun map_some_example(): u8 {
        let opt = Option::some(10u8);
        let lambda: |u8| u8 = |x: u8| { x + 1 };
        let mapped = map<U8>(opt, lambda);
        if (Option::is_some(&mapped)) {
            *Option::unwrap(&mapped)
        } else {
            0
        }
    }

    public fun map_none_example(): u8 {
        let opt = Option::none<u8>();
        let lambda: |u8| u8 = |x: u8| { x + 1 };
        let mapped = map<u8>(opt, lambda);
        if (Option::is_some(&mapped)) {
            *Option::unwrap(&mapped)
        } else {
            42
        }
    }

    // Helper function for map calling
    public fun map<T, U>(opt: Option::Option<T>, f: |T|U): Option::Option<U> {
        if (Option::is_some(&opt)) {
            Option::some(f(*Option::unwrap(&opt)))
        } else {
            Option::none()
        }
    }
}

//# run 0xCAFEDEAD::OptionUsage::map_some_example

//# run 0xCAFEDEAD::OptionUsage::map_none_example

// Featurres:
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 01a43e94f76e7d519185aeeff2c06acb: Merge specification modules into target modules to associate specifications with implementations.
// 2546adaf47f70b2598c1cbdc28df4fc3: Test that the map function correctly transforms a some option value by applying a given function.
