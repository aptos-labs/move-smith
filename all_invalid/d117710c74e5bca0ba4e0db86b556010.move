
//# publish
module 0xCAFE::MapConversion {
    use std::string;
    use std::symbol;
    use std::vector;
    use std::table;
    use std::option;

    // A helper function to convert a vector<u8> (string bytes) to Symbol
    // This is public to be called from outside, inline attribute
    public inline fun string_to_symbol(s: vector<u8>): symbol::Symbol {
        symbol::new(s)
    }

    // Inline function declared
    public inline fun inline_add(a: u64, b: u64): u64 {
        a + b
    }

    // Converts a table with string keys to a table with symbol keys
    public fun convert_map_string_to_symbol(input: table::Table<vector<u8>, u64>): table::Table<symbol::Symbol, u64> {
        let output = table::new<symbol::Symbol, u64>();
        let keys = table::keys(&input);
        
        let length = vector::length(&keys);
        let i = 0; // i needs to be mutable to increment
        while (i < length) {
            let key_string = *vector::borrow(&keys, i);
            let val = match table::borrow(&input, key_string) {
                option::Some(v) => *v,
                option::None => 0,
            };
            let sym = string_to_symbol(key_string);
            table::add(&mut output, sym, val);
            i = i + 1;
        };
        output
    }

    // Runner function that creates a string keyed map, converts to symbol keyed map and returns the sum of values
    public fun runner(): u64 {
        let map_str = table::new<vector<u8>, u64>();
        table::add(&mut map_str, b"one", 1u64);
        table::add(&mut map_str, b"two", 2u64);
        table::add(&mut map_str, b"three", 3u64);

        let map_sym = convert_map_string_to_symbol(map_str);

        // Sum all values in symbol-keyed map
        let keys = table::keys(&map_sym);
        let length = vector::length(&keys);
        let i = 0; // i needs to be mutable here too
        let sum = 0u64; // sum should be mutable because updated in loop
        while (i < length) {
            let sym_key = *vector::borrow(&keys, i);
            let val_opt = table::borrow(&map_sym, sym_key);
            match val_opt {
                option::Some(v) => { sum = sum + *v; },
                option::None => {},
            };
            i = i + 1;
        };
        sum
    }
}




//# run 0xCAFE::MapConversion::runner




//# publish
module 0xCAFE::LiteralAddressUsage {
    use std::signer;

    // Function uses a literal address to move a resource to that address
    struct Resource has key, store {
        val: u8,
    }

    public fun publish_resource_to_literal_address(s: signer, v: u8) {
        let res = Resource {val: v};
        move_to<Resource>(&s, res);
    }

    public fun borrow_resource_from_literal_address(): u8 {
        let addr = @0xDEADBEEF;
        let res_ref = borrow_global<Resource>(addr);
        res_ref.val
    }
}



//# run 0xCAFE::LiteralAddressUsage::publish_resource_to_literal_address --signers 0xDEADBEEF --args 42u8



//# run 0xCAFE::LiteralAddressUsage::borrow_resource_from_literal_address
