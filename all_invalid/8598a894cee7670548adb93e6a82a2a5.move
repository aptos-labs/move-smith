//# publish
#[deprecated]
address 0xCAFEDEAD {
    module Option {
        use 0x1::Std;

        struct Option<T> has store {
            is_some: bool,
            value: T,
        }

        public fun some<T>(value: T): Option<T> {
            Option<T> {is_some: true, value}
        }

        public fun none<T>(): Option<T> {
            // We use dummy value for none variant, since Move does not have nullable types
            Option<T> {is_some: false, value: Std::zero<T>()}
        }

        public fun is_some<T>(opt: &Option<T>): bool {
            opt.is_some
        }

        public fun unwrap<T>(opt: &Option<T>): &T {
            assert!(opt.is_some, 0);
            &opt.value
        }

        // Helper function for map calling
        public fun map<T, U>(opt: Option<T>, f: &fun(T): U): Option<U> {
            if (Option::is_some(&opt)) {
                Option::some(f(*Option::unwrap(&opt)))
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
        let lambda: &fun(u8): u8 = &fun(x: u8): u8 { x + 1 };
        let mapped = Option::map(opt, lambda);
        if (Option::is_some(&mapped)) {
            *Option::unwrap(&mapped)
        } else {
            0
        }
    }

    public fun map_none_example(): u8 {
        let opt = Option::none<u8>();
        let lambda: &fun(u8): u8 = &fun(x: u8): u8 { x + 1 };
        let mapped = Option::map(opt, lambda);
        if (Option::is_some(&mapped)) {
            *Option::unwrap(&mapped)
        } else {
            42
        }
    }
}

//# run 0xCAFEDEAD::OptionUsage::map_some_example

//# run 0xCAFEDEAD::OptionUsage::map_none_example