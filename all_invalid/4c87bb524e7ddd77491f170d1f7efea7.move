//# publish
module 0xCAFE::LanguageFeaturesTest {
    use std::vector;

    // Version-dependent feature: const generic parameters (requires Move 1.5+)
    const MAX_SIZE: u8 = 255;

    // Function to test `filter_program` concept by removing specific functions
    public fun filter_function_by_name(name: &vector<u8>): bool {
        vector::index_of(name, b"target_function") != std::option::none()
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
    public fun test_filter_program(): vector<bool> {
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut names, b"target_function");
        vector::push_back(&mut names, b"exclude_function");
        let filtered = filter_program_based_on_criteria(names);
        filtered
    }

    // Define a module at a named address with no explicit address (local module scope)
    // Corrected placement: Place the anonymous module *inside* the outer module with a designated name or as a submodule
    // Move the anonymous module inside the main module as a nested module (Move current syntax does not support anonymous modules standalone)
    // To simulate a local unnamed module, define it as a nested module with a suitable name, e.g., 'local_module'
//# publish
    module local_module {
        // Function using a `while` loop with the language feature requiring a certain version
        public fun loop_with_break_condition(): u64 {
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

    // Corrected placement of nested module; no anonymous module syntax allowed outside of an address scope

    // Define a module at a named address with explicit address, e.g., 0xCAFE
    // (This appears correctly in the original, so no changes needed here.)

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
            // Use the variables here or just for compilation purpose
        }
    }
}
