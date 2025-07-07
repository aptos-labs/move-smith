//# publish
module 0xCAFE::PackagePaths {
    use std::string;
    use std::symbol;
    use std::vector;
    use std::option;

    /// A simple string-to-string map type alias
    struct StringMap has copy, drop, store {
        keys: vector::Vector<string::String>,
        values: vector::Vector<string::String>,
    }

    /// A simple symbol-to-symbol map type alias
    struct SymbolMap has copy, drop, store {
        keys: vector::Vector<symbol::Symbol>,
        values: vector::Vector<symbol::Symbol>,
    }

    /// A struct representing a package map with named_address_map field
    struct PackagePaths has copy, drop, store {
        named_address_map: StringMap,
    }

    /// Converts a vector of String keys and values to a vector of Symbol keys and values
    /// for the named_address_map field.
    public fun string_map_to_symbol_map(map: StringMap): SymbolMap {
        let keys_len = vector::length(&map.keys);
        let mut keys_sym = vector::empty<symbol::Symbol>();
        let mut values_sym = vector::empty<symbol::Symbol>();

        let mut i = 0;
        while (i < keys_len) {
            let key_str = *vector::borrow(&map.keys, i);
            let val_str = *vector::borrow(&map.values, i);

            let key_sym = symbol::new(key_str);
            let val_sym = symbol::new(val_str);

            vector::push_back(&mut keys_sym, key_sym);
            vector::push_back(&mut values_sym, val_sym);

            i = i + 1;
        };

        SymbolMap {
            keys: keys_sym,
            values: values_sym
        }
    }

    /// A public function that returns a sample PackagePaths with string map initialized
    public fun sample_package(): PackagePaths {
        let keys = vector::empty<string::String>();
        let values = vector::empty<string::String>();

        vector::push_back(&mut keys, string::utf8(b"Key1"));
        vector::push_back(&mut keys, string::utf8(b"Key2"));
        vector::push_back(&mut values, string::utf8(b"Value1"));
        vector::push_back(&mut values, string::utf8(b"Value2"));

        PackagePaths {
            named_address_map: StringMap { keys, values }
        }
    }

    /// Runner function to test the string_map_to_symbol_map function;
    /// Converts the sample PackagePaths named_address_map and returns the length of keys
    public fun runner(): u64 {
        let pkg = sample_package();
        let symbol_map = string_map_to_symbol_map(pkg.named_address_map);
        vector::length(&symbol_map.keys) as u64
    }
}

//# run 0xCAFE::PackagePaths::runner


//# publish
module 0xCAFE::MutateTest {
    /// Struct to hold mutable counter
    struct Counter has copy, drop, store {
        x: u64,
    }

    /// Initializes a Counter with x = 0
    public fun init(): Counter {
        Counter { x: 0 }
    }

    /// Increments the counter in place by 1
    public fun inc(c: &mut Counter) {
        c.x = c.x + 1;
    }

    /// Tests in-place mutation and accumulation by calling inc 5 times and returning x
    public fun test(): u64 {
        let mut counter = init();
        let mut i = 0;
        while (i < 5) {
            inc(&mut counter);
            i = i + 1;
        };
        counter.x
    }
}

//# run 0xCAFE::MutateTest::test


//# publish
module 0xCAFE::ExpectedFailureTest {
    /// Function that aborts intentionally with code 123
    public fun will_abort(): u64 {
        abort 123;
    }

    #[expected_failure(123)]
    public fun test_abort() {
        will_abort();
    }
}

//# run 0xCAFE::ExpectedFailureTest::test_abort

// Featurres:
// 5ac5312e0886432f5e1443dbd24ff895: Transform the 'named_address_map' within PackagePaths from String keys and values to Symbol keys and values using 'string_map_to_symbol_map'.
// b2d74da62124bc08a6dc7513a04ad40c: Use the `#[expected_failure(...)]` attribute to specify expected errors or abort codes in your tests.
// 3ec81caac0abb53d66246c0ca58d1ffe: Test that calling the `test` function correctly updates and aggregates the mutable variable `x` through multiple calls to `inc`, demonstrating proper in-place mutation and accumulation.
