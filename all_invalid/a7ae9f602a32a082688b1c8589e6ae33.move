//# publish
module 0xA550::TestModule {
    use std::string;
    use std::vector;
    use std::debug;

    // Transformation test: Convert string_map to symbol_map
    public fun string_map_to_symbol_map<K: copy + drop, V: copy + drop>(
        map: vector<(string::String, string::String)>
    ): vector<(symbol, symbol)> {
        // Placeholder for transformation logic
        // For testing purposes, just map strings to symbols
        let mut result = vector::empty<(symbol, symbol)>();
        let len = vector::len(&map);
        let mut i = 0;
        while (i < len) {
            let (k_str, v_str) = vector::borrow(&map, i);
            // Convert strings to symbols (simulate)
            let sym_k = symbol(k_str);
            let sym_v = symbol(v_str);
            vector::push_back(&mut result, (sym_k, sym_v));
            i = i + 1;
        };
        result
    }

    // Analyze function parameters and local variables
    public fun analyze_function_usage(param1: u64, param2: vector<u8>) {
        let local_var = param1 + 42;
        let mut counter = 0;
        while (counter < vector::length(&param2)) {
            let byte = *vector::borrow(&param2, counter);
            debug::print(&byte);
            counter = counter + 1;
        };
    }

    // Define inline functions with bodies (not native)
    public inline fun inline_add(x: u64, y: u64): u64 {
        x + y
    }

    // Runner function to test inline functions
    public fun run_inline_add_and_transform() {
        let sum = inline_add(10, 20);
        debug::print(&sum);

        let string_map = vector::singleton<(string::String, string::String)>(
            (string::utf8(b"key1"), string::utf8(b"value1"))
        );
        let symbol_map = string_map_to_symbol_map(string_map);
        // For debugging, print the symbol map
        // (Suppose a debug::print_symbols exists)
        // debug::print_symbols(&symbol_map);
    }
}
//# run 0xA550::TestModule::run_inline_add_and_transform