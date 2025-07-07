//# publish
module 0x42::map_opt {
    use std::option;

    /// Maps the content of an option using the provided function
    public inline fun map<Element, OtherElement>(
        t: option::Option<Element>,
        f: |Element| OtherElement
    ): option::Option<OtherElement> {
        if (option::is_some(&t)) {
            option::some(f(option::extract(&mut t)))
        } else {
            option::none()
        }
    }

    /// Map with default value if none
    public fun map_or<Element, OtherElement>(
        t: option::Option<Element>,
        default: OtherElement,
        f: |Element| OtherElement
    ): OtherElement {
        if (option::is_some(&t)) {
            f(option::extract(&mut t))
        } else {
            default
        }
    }
}

//# publish
module 0x42::Test {
    use std::option;
    use 0x42::map_opt;

    /// Test mapping over a some value
    public fun test_map_some(): u64 {
        let t = option::some(10);
        let result = map_opt::map(t, |e| e * 2);
        option::extract(&mut result)
    }

    /// Test mapping over a none value
    public fun test_map_none(): u64 {
        let t: option::Option<u64> = option::none();
        let result = map_opt::map(t, |e| e * 2);
        // Expect None to stay None, so extract would panic in real, but for test, assume safe
        // Since no assertions, just return 0 if none
        if (option::is_some(&result)) {
            option::extract(&mut result)
        } else {
            0
        }
    }

    /// Test map_or with some value
    public fun test_map_or_some(): u64 {
        let t = option::some(5);
        map_opt::map_or(t, 99, |e| e + 3)
    }

    /// Test map_or with none
    public fun test_map_or_none(): u64 {
        let t: option::Option<u64> = option::none();
        map_opt::map_or(t, 42, |e| e + 3)
    }

    /// Runner function to invoke all tests
    public fun run_all_tests() {
        // call all test functions to ensure they compile
        let _ = test_map_some();
        let _ = test_map_none();
        let _ = test_map_or_some();
        let _ = test_map_or_none();
    }
}

//# run 0x42::Test::run_all_tests