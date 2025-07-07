//# publish
module 0x1::StringToSymbolMap {
    use std::string;
    use std::symbol;
    use std::string::String;
    use std::symbol::Symbol;
    use std::vector;

    // Convert a map from string keys and values to symbol keys and values
    public fun string_map_to_symbol_map(map: vector<(String, String)>): vector<(Symbol, Symbol)> {
        let mut sym_map = vector::empty<(Symbol, Symbol)>();
        let len = vector::length(&map);
        let mut i = 0;
        while (i < len) {
            let (key_str, val_str) = *vector::borrow(&map, i);
            let key_sym = symbol::make(&key_str);
            let val_sym = symbol::make(&val_str);
            vector::push_back(&mut sym_map, (key_sym, val_sym));
            i = i + 1;
        }
        sym_map
    }

    // Helper function to create a string from a &str literal
    public fun str_to_string(val: &String): String {
        string::utf8(val)
    }

    // Runner function for testing string_map_to_symbol_map
    public fun run() {
        let input: vector<(String, String)> = vector::empty();
        let k0 = string::utf8("module_name");
        let v0 = string::utf8("0x1");
        vector::push_back(&mut input, (k0, v0));
        let k1 = string::utf8("another_name");
        let v1 = string::utf8("0x2");
        vector::push_back(&mut input, (k1, v1));

        let sym_map = string_map_to_symbol_map(input);
        // no assertions needed, just exercising compiler/VM
        // This ensures keys and vals are converted to Symbol type
        let _ = sym_map;
    }
}
//# run 0x1::StringToSymbolMap::run

//# publish
module 0x1::FunctionParameters {
    use std::signer;

    // Function with explicit argument names and types
    public fun add_numbers(a: u64, b: u64): u64 {
        a + b
    }

    // Function that accepts a signer parameter explicitly
    public fun check_signer(s: &signer): bool {
        signer::address_of(s) == @0xBEEF
    }

    // Runner function exercises the above functions with variable names.
    public fun run() {
        let x: u64 = 10;
        let y: u64 = 20;
        let _sum = add_numbers(x, y);

        // dummy signer to test check_signer would be done by VM with signer
        // but here just show using a variable name of type &signer
        // no assertions needed
    }
}
//# run 0x1::FunctionParameters::run

//# run
script {
    use std::signer;
    use 0x1::StringToSymbolMap;
    use 0x1::FunctionParameters;

    fun main(s: signer) {
        // Testing '@' sign for parsing address literal
        let addr: address = @0xBEEF;

        // Prepare map vector<(String, String)> using string::utf8
        let mut map: vector<(string::String, string::String)> = vector::empty();
        let key = string::utf8("key1");
        let val = string::utf8("val1");
        vector::push_back(&mut map, (key, val));

        // call the function to convert string map to symbol map
        let sym_map = StringToSymbolMap::string_map_to_symbol_map(map);

        // call function with explicit params
        let sum = FunctionParameters::add_numbers(50, 70);

        // call check_signer with signer s
        let _is_bnef = FunctionParameters::check_signer(&s);

        // no assertions needed, this run tests passing addresses with '@', variable naming,
        // and calling published module functions with arguments.
        let _ = (addr, sym_map, sum);
    }
}