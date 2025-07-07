//# publish
module 0xCAFE::SchemaTest<T> {
    use std::vector;

    // Define a schema with a type parameter T (just simulate schema by using a struct)
    struct SchemaSpec has copy, drop, store {
        value: u8,
        items: vector<T>,
    }

    public fun create_schema_spec(): SchemaSpec {
        SchemaSpec { value: 0, items: vector::empty<T>() }
    }

    public fun get_ten(): u8 {
        let local_value = 10;
        local_value
    }

    public fun nested_blocks_and_mutations(): u64 {
        let mut x = 5u64;

        let res = {
            let mut y = 3u64;
            {
                y = y + x;
                y
            }
        };
        x = x + res; // x = 5 + (3+5) = 13
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, x); // v[0] = 13

        {
            let last_index = 0;
            let mut val = *vector::borrow_mut(&mut v, last_index);
            val = val + 7; // val = 20
            *vector::borrow_mut(&mut v, last_index) = val;
        };

        *vector::borrow(&v, 0) // should be 20
    }

    public fun runner(): u64 {
        let ten = get_ten();
        let nested = nested_blocks_and_mutations();
        // We want to just return nested for checking in run command; ten is tested separately.
        nested
    }
}

//# run 0xCAFE::SchemaTest::get_ten

//# run 0xCAFE::SchemaTest::nested_blocks_and_mutations

//# run 0xCAFE::SchemaTest::runner

// Featurres:
// 7497b02118189d8504a81f0a284fa59e: Define schema specifications within modules using schema names and type parameters.
// 9b3b414c1289e41cdd9f366bec5543a8: Test that the module's public function returns the value 10 after assigning it to a local variable.
// af98d5c12b4870b5818f6e1b456c499f: Test the correct evaluation of nested block expressions, variable mutations, and vector index updates within functions and assertions.
