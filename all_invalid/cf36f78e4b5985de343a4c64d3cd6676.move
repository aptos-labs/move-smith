//# publish
module 0xA55::test_module {
    use std::string;
    use std::vector;
    use std::move;

    // Function to transform a string_map to a symbol_map
    public fun string_map_to_symbol_map(map: vector<(string::String, string::String)>): vector<(symbol::Symbol, symbol::Symbol)> {
        let mut result = vector::empty<(symbol::Symbol, symbol::Symbol)>();
        let len = vector::length(&map);
        let mut i = 0;
        while (i < len) {
            let (key_str, value_str) = vector::borrow(&map, i);
            let key_sym = symbol::Symbol::new(key_str);
            let value_sym = symbol::Symbol::new(value_str);
            vector::push_back(&mut result, (key_sym, value_sym));
            i = i + 1;
        }
        result
    }

    // Inline non-natively defined function with body
    public fun process_symbols(sym1: symbol::Symbol, sym2: symbol::Symbol): bool {
        // Simple comparison inside function body
        symbol::equals(&sym1, &sym2)
    }

    // Inline function that performs analysis of parameters and variables
    public fun analyze_function_usage(param: u64): bool {
        // Use local variable to analyze usage
        let local_var = param + 42;
        local_var > param
    }

    // Runner function to test the above functions
    public fun run_tests() {
        let string_map = vector::empty<(string::String, string::String)>();
        vector::push_back(&mut string_map, (string::utf8(b"key1"), string::utf8(b"value1")));
        vector::push_back(&mut string_map, (string::utf8(b"key2"), string::utf8(b"value2")));

        let symbol_map = string_map_to_symbol_map(move(string_map));
        // Call process_symbols with two symbols
        // For testing, pick first two keys
        let (k1, v1) = vector::borrow(&symbol_map, 0);
        let (k2, v2) = vector::borrow(&symbol_map, 1);
        let result = process_symbols(*k1, *k2);
        // Call analyze_function_usage
        let usage_result = analyze_function_usage(100);
    }
}

//# run 0xA55::test_module::run_tests