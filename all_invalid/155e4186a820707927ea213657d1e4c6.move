
//# publish
module 0xCAFE::InteractionTest {
    use std::vector;
    use std::signer;
    use 0xCAFE::MyModule;

    // Script entry point to test invoking various module functions and verify parameters
    public fun test_invoke_module_functions(s: signer) {
        // Call module functions
        let _ = 0xCAFE::MyModule::f1(3u8, true);
        let _ = 0xCAFE::MyModule::f3(15u16);
        // Call inline function with tuple return
        let (a, b) = 0xCAFE::MyModule::f2(20u16);
        // Call a function with multiple control structures
        let val = 0xCAFE::MyModule::f8();

        // Call a function with a lambda
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        let (sum, prod) = lambda(4u8, 5u8);
    }

    // Using a while loop to modify local vars and test shadowing and var scope
    public fun test_while_loop(s: signer): u64 {
        let counter = 0u64;
        let shadowed = 0u64;
        let outer_var = 10u64;

        // Shadow the 'shadowed' variable inside loop
        while (counter < 5) {
            let shadowed = counter * 2; // Shadowing outer variable
            counter = counter + 1;
        };
        // Use outer variables to create final result
        outer_var + counter + shadowed
    }

    // Internal function that should not be accessible from outside module
    fun internal_function(x: u64): u64 {
        x * 2
    }

    // Function that calls internal function internally
    public fun call_internal(x: u64): u64 {
        internal_function(x)
    }

    // Symbol type simulation using a simple struct as key
    struct Symbol has copy, drop, store, key {
        id: u64,
        label: vector<u8>,
    }

    // Map from symbol to u64 value
    struct SymbolTable has key {
        map: vector<(Symbol, u64)>,
    }

    public fun create_symbol(id: u64, label_bytes: vector<u8>): Symbol {
        Symbol {id, label: label_bytes}
    }

    public fun insert_symbol_value(table: &mut SymbolTable, sym: Symbol, value: u64) {
        vector::push_back(&mut table.map, (sym, value));
    }

    public fun lookup_symbol_value(table: &SymbolTable, sym: &Symbol): option<u64> {
        let i = 0;
        let len = vector::length(&table.map);
        while (i < len) {
            let (key_sy, val) = &vector::borrow(&table.map, i);
            if (key_sy.id == sym.id) {
                return option::some(*val);
            };
            i = i + 1;
        };
        option::none()
    }

    // List parser: function that takes list of comma-separated items within tokens
    // For simplicity, the list is provided as a vector of u8, with tokens at start/end
    public fun parse_tokened_list(list_bytes: vector<u8>, start_token: u8, end_token: u8): vector<vector<u8>> {
        let result = vector::empty<vector<u8>>();
        let current_item = vector::empty<u8>();
        let is_inside = false;
        let len = vector::length(&list_bytes);
        let index = 0;
        while (index < len) {
            let byte = *vector::borrow(&list_bytes, index);
            if (byte == start_token) {
                is_inside = true;
                // Start a new item
                current_item = vector::empty<u8>();
            } else if (byte == end_token) {
                // End current item and add to result
                is_inside = false;
                vector::push_back(&mut result, current_item);
            } else {
                if (is_inside) {
                    vector::push_back(&mut current_item, byte);
                };
            };
            index = index + 1;
        };
        result
    }

    // Runner function to execute combined tests
    public fun run_all_tests(s: signer) {
        // Invoke module functions
        self::test_invoke_module_functions(s);
        // Test while loop variable behaviors
        let final_value = self::test_while_loop(s);
        // Call internal function via public wrapper
        let internal_result = self::call_internal(7);
        // Create symbols and test lookup
        let sym1 = self::create_symbol(1, b"alpha");
        let sym2 = self::create_symbol(2, b"beta");
        let table = SymbolTable {map: vector::empty<(Symbol, u64)>()};
        self::insert_symbol_value(&mut table, sym1, 100);
        self::insert_symbol_value(&mut table, sym2, 200);
        let res1 = self::lookup_symbol_value(&table, &sym1);
        let res2 = self::lookup_symbol_value(&table, &sym2);
        // Parse list with tokens '[' and ']'
        let raw_list = b"[item1,item2,item3]";
        let parsed = self::parse_tokened_list(raw_list, '[', ']');
        // Last expression to ensure execution
        (final_value, internal_result, res1, res2, parsed)
    }
}
