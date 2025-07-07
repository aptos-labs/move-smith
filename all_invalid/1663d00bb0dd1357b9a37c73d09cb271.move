
//# publish
module 0xCAFE::UniqueModulesCollection {
    use std::vector;
    use std::error;
    use std::debug;
    use std::unique_map;

    const E_DUPLICATE: u64 = 1;

    struct ModuleInfo has copy, drop, store {
        name: vector<u8>,
        version: u8,
    }

    struct Collection has store {
        map: unique_map::UniqueMap<vector<u8>, ModuleInfo>,
    }

    public fun new_collection(): Collection {
        let map = unique_map::empty<vector<u8>, ModuleInfo>();
        Collection { map }
    }

    public fun add_module(c: &mut Collection, name: vector<u8>, version: u8) {
        if (unique_map::contains_key(&c.map, &name)) {
            debug::print(b"Error: Duplicate module name found");
            abort error::invalid_state(E_DUPLICATE);
        };
        let module_info = ModuleInfo { name: vector::copy(&name), version };
        unique_map::insert(&mut c.map, name, module_info);
    }

    public fun iterate_and_print(c: &Collection) {
        let keys = unique_map::key_cloned_iter(&c.map);
        vector::for_each(&keys, |key: vector<u8>| {
            let module_info = unique_map::borrow(&c.map, &key);
            debug::print(&module_info.name);
            debug::print(b": version ");
            debug::print(&vector::from_u8(module_info.version));
        });
    }

    public fun runner() {
        let c = new_collection();
        add_module(&mut c, b"Module1", 1);
        add_module(&mut c, b"Module2", 5);
        iterate_and_print(&c);
    }
}



//# run 0xCAFE::UniqueModulesCollection::runner



//# publish
module 0xCAFE::FakeParserParser {
    use std::vector;
    use std::debug;

    // Emulate parsing a Move source string, return error diagnostics if invalid
    public fun parse_source(source: &vector<u8>): bool {
        let invalid_keyword = b"invalid";
        let source_len = vector::length(source);
        let pos = 0;
        while (pos < source_len) {
            let slice_end = pos + vector::length(invalid_keyword);
            // Only attempt sub_range if within bounds
            if (slice_end > source_len) {
                break;
            };
            let slice = vector::sub_range(source, pos, slice_end);
            if (slice == invalid_keyword) {
                debug::print(b"Parsing error: found invalid token 'invalid'");
                return false;
            };
            pos = pos + 1;
        };
        debug::print(b"Parsing success");
        true
    }

    public fun runner_valid() {
        let good_code = b"module 0xCAFE::Test { }";
        parse_source(&good_code);
    }

    public fun runner_invalid() {
        let bad_code = b"module invalid 0xCAFE::Test { }";
        parse_source(&bad_code);
    }
}



//# run 0xCAFE::FakeParserParser::runner_valid



//# run 0xCAFE::FakeParserParser::runner_invalid


//# run
script {
    use std::debug;
    use std::vector;

    const CONST_VAL: u64 = 42;

    fun helper_fun(x: u64): u64 {
        x * 2
    }

    fun main() {
        debug::print(b"Running script with attribute, constant, function");

        let v = CONST_VAL;
        let res = helper_fun(v);

        debug::print(&vector::from_u8((res as u8)));
    }
}
