
//# publish
module 0xCAFE::MapEnumLabelTest {
    use std::string;

    // A map from byte string (location file hash) to u64 (file id)
    struct LocationToFileIdMap has store {
        // keys and values stored as parallel vectors (simple map pattern)
        keys: vector<vector<u8>>,
        values: vector<u64>,
    }

    public fun empty_map(): LocationToFileIdMap {
        LocationToFileIdMap {
            keys: vector::empty<vector<u8>>(),
            values: vector::empty<u64>(),
        }
    }

    // Insert or update the mapping with given key and value
    public fun insert_or_update(map: &mut LocationToFileIdMap, key: vector<u8>, value: u64) {
        let i = 0;
        let len = vector::length(&map.keys);
        // search for existing key
        while (i < len) {
            if (string::equals_bytes(&map.keys[i], &key)) {
                // update value
                *vector::borrow_mut(&mut map.values, i) = value;
                return;
            };
            i = i + 1;
        };
        // not found, insert
        vector::push_back(&mut map.keys, key);
        vector::push_back(&mut map.values, value);
    }

    // Get value by key, return OptionFileId variant
    public fun get_value(map: &LocationToFileIdMap, key: vector<u8>): FileIdOption {
        let i = 0;
        let len = vector::length(&map.keys);
        while (i < len) {
            if (string::equals_bytes(&map.keys[i], &key)) {
                let v = *vector::borrow(&map.values, i);
                return FileIdOption::Some(v);
            };
            i = i + 1;
        };
        FileIdOption::None
    }

    // Define complex enum with multiple variants including block-structured variant and optional trailing comma
    enum FileIdOption has copy, drop {
        None,
        Some(u64),
        Info {
            id: u64,
            active: bool,
        },
    }

    // Return an enum variant from function based on id parity
    public fun file_id_option_from_id(id: u64): FileIdOption {
        if (id % 2 == 0) {
            FileIdOption::Info {
                id,
                active: true,
            }
        } else {
            FileIdOption::Some(id)
        }
    }

    // Test labeled blocks with map and enum
    public fun labeled_blocks_test(): u64 {
        let map = empty_map();

        // insert some entries with labeled block
        'insert_block: {
            insert_or_update(&mut map, b"fileA", 101);
            insert_or_update(&mut map, b"fileB", 202);
            insert_or_update(&mut map, b"fileC", 303);
            // break insert_block early if fileB present
            let val = get_value(&map, b"fileB");
            match (val) {
                FileIdOption::None => {},
                _ => { break 'insert_block; }
            };
        };

        let result = 0u64;

        'outer: for (i in 0..vector::length(&map.keys)) {
            let key = vector::borrow(&map.keys, i);
            let val = *vector::borrow(&map.values, i);
            // Use enum function
            let file_enum = file_id_option_from_id(val);

            'inner: {
                match (file_enum) {
                    FileIdOption::None => { continue 'outer; },
                    FileIdOption::Some(id) => {
                        // if id divisible by 101, add id to result and break inner
                        if (id % 101 == 0) {
                            result = result + id;
                            break 'inner;
                        };
                    },
                    FileIdOption::Info { id, active } => {
                        if (active) {
                            result = result + id * 2;
                            // break out of outer loop early
                            break 'outer;
                        };
                    },
                };
            };
        };

        result
    }
}


//# run 0xCAFE::MapEnumLabelTest::insert_or_update --args b"fileX" 999u64


//# run 0xCAFE::MapEnumLabelTest::get_value --args b"fileX"


//# run 0xCAFE::MapEnumLabelTest::file_id_option_from_id --args 42u64


//# run 0xCAFE::MapEnumLabelTest::labeled_blocks_test


// Featurres:
// a900487cdf8675dd3f9bae796a3f99a5: Map a location's file hash to its corresponding file identifier.
// f25d1f528a8707df554044d60496d074: Use the syntax for enumerations with variants, optionally including block-structured variants and allowing optional commas between variants, enclosed within braces.
// b2fe2ba0fc5f4483ab8510aa33fd8420: Label code blocks for advanced control flow using labels
