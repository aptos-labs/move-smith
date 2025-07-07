
//# publish
module 0xCAFE::LanguageFeaturesTest {
    use std::vector;

    // Version-dependent feature: const generic parameters (requires Move 1.5+)
    const MAX_SIZE: u8 = 255;

    // Function to test `filter_program` concept by removing specific functions
    public fun filter_function_by_name(name: &vector<u8>): bool {
        vector::index_of(name, b"target_function")
    }

    // Function to test filter program functionality: should exclude functions with "exclude" in their name
    public fun filter_program_based_on_criteria(names: vector<vector<u8>>): vector<bool> {
        let results = vector::empty<bool>();
        let len = vector::length(&names);
        let i = 0;
        while (i < len) {
            let name = vector::borrow(&names, i);
            let include = !filter_function_by_name(name);
            vector::push_back(&mut results, include);
            i = i + 1;
        };
        results
    }

    // Example functions to be filtered
    public fun target_function() {
        // intentionally left blank
    }

    public fun exclude_function() {
        // intentionally left blank
    }

    // Function that uses filter_program to filter functions by name
    public fun test_filter_program() {
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut names, b"target_function");
        vector::push_back(&mut names, b"exclude_function");
        let filtered = filter_program_based_on_criteria(names);
        filtered
    }

    // Define a module at a named address with no explicit address (local module scope)
//# publish
    module 0xCAFE::NamedAddressModule {
        // Using a struct with a type parameter to test generics
        struct GenericStruct<T> has copy, drop, store {
            value: T
        }

        public fun create_generic_struct<T: copy + drop + store>(val: T): GenericStruct<T> {
            let s = GenericStruct { value: val };
            s
        }

        // Function to invoke create_generic_struct with different types
        public fun run_create_generic_struct() {
            let s_u8 = create_generic_struct(42u8);
            let s_bool = create_generic_struct(true);
        }
    }

    // Define an anonymous module (no address) with functions utilizing features that depend on language version
//# publish
    module // no explicit address, local to current scope
    {
        // Function using a `while` loop with the language feature requiring a certain version
        public fun loop_with_break_condition() {
            let x: u64 = 0;
            while (x < MAX_SIZE as u64) {
                x = x + 1;
            };
            x
        }

        // Use of a nested if to test syntax parsing
        public fun nested_if_test(flag: bool): u8 {
            if (flag) {
                if (flag) {
                    1
                } else {
                    2
                }
            } else {
                3
            }
        }

        // Function that executes a match statement (soft types, but testing language features)
        public fun match_test(val: u8): u8 {
            match (val) {
                0 => 10,
                1 => 20,
                _ => 30,
            }
        }
    }
}


//# run 0xCAFE::LanguageFeaturesTest::test_filter_program


//# run 0xCAFE::LanguageFeaturesTest::loop_with_break_condition


//# run 0xCAFE::LanguageFeaturesTest::nested_if_test --args 1u8


//# run 0xCAFE::LanguageFeaturesTest::match_test --args 2u8

// No explicit calls to version-dependent features are made outside the module,
// but the functions within exercise language features requiring certain compiler versions.


// Featurres:
// bbbc9c0cd146e4bac89b8e3b9201cf08: Use language features that require a specific minimum Move language version.
// bad7c9c9d84bdc36f18685e0acaa3ac5: Use filter_program to remove module members based on specified criteria.
// 458ed8c095ed45a70efa17beccd41108: Define modules at named addresses by providing an address before '::' and the module name, or create modules without an explicit address for named modules.
