//# publish
module 0x1::test_module {

    // A simple function to test map on Option<T>
    public fun map_option<T, U>(
        opt: &Option<T>,
        f: &fun(T): U
    ): Option<U> {
        if (Option::is_some(opt) ) {
            let value = Option::extract(opt);
            Option::some(f(&value))
        } else {
            Option::none()
        }
    }

    // Test helper: increment function
    public fun increment(x: &u64): u64 {
        *x + 1
    }

    // Create a list of pairs by transforming each element in a range list
    public fun range_to_pairs(start: u64, end: u64): vector<(u64, u64)> {
        let mut list = vector::empty<(u64, u64)>();
        let mut i = start;
        while (i < end) {
            let pair = (i, 2 * i);
            vector::push_back(&mut list, pair);
            i = i + 1;
        }
        list
    }

    // Function to unpack an optional type parameter and verify processing
    public fun process_optional<T>(opt_opt: Option<Option<T>>): Option<T> {
        match opt_opt {
            Option::Some(opt_inner) => {
                // If inner option is some, return that
                match &opt_inner {
                    Option::Some(val) => Option::some((*val)),
                    Option::None => Option::none(),
                }
            },
            Option::None => Option::none(),
        }
    }

    // Runner function to execute tests
    public fun run_tests() {
        // Test 1: map on some
        let some_value = Option::some(41u64);
        let mapped_some = map_option(&some_value, &increment);
        assert!(Option::is_some(&mapped_some));
        assert!(*Option::extract(&mapped_some) == 42);

        // Test 2: map on none
        let none_value: Option<u64> = Option::none();
        let mapped_none = map_option(&none_value, &increment);
        assert!(Option::is_none(&mapped_none));

        // Test 3: range to pairs
        let pairs = range_to_pairs(1, 4); // should produce [(1,2), (2,4), (3,6)]
        assert!(vector::length(&pairs) == 3);
        assert!(vector::borrow(&pairs, 0).0 == 1);
        assert!(vector::borrow(&pairs, 0).1 == 2);
        assert!(vector::borrow(&pairs, 1).0 == 2);
        assert!(vector::borrow(&pairs, 1).1 == 4);
        assert!(vector::borrow(&pairs, 2).0 == 3);
        assert!(vector::borrow(&pairs, 2).1 == 6);

        // Test 4: process optional nested option
        let some_inner: Option<u64> = Option::some(100);
        let outer_some: Option<Option<u64>> = Option::some(some_inner);
        let result_some = process_optional(outer_some);
        assert!(Option::is_some(&result_some));
        assert!(*Option::extract(&result_some) == 100);

        let outer_none: Option<Option<u64>> = Option::none();
        let result_none = process_optional(outer_none);
        assert!(Option::is_none(&result_none));

        let inner_none: Option<u64> = Option::none();
        let outer_inner_none: Option<Option<u64>> = Option::some(inner_none);
        let result_inner_none = process_optional(outer_inner_none);
        assert!(Option::is_none(&result_inner_none));
    }
}

 //# run 0x1::test_module::run_tests