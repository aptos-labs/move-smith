
//# publish
module 0xCAFE::InteractionTest {
    use std::vector;

    // Example module to import and test aliasing
//# publish
    module 0xDEAD::SubModule {
        public fun sub_func() {}
    }
    
    // Spec block, simulating a schema or module specification
    // (In reality, spec blocks are not executable Move code, but for the test, we mimic their interaction)
    struct SpecBlock has store {
        schema_name: vector<u8>,
        member_names: vector<vector<u8>>,
        alias_generated: bool,
    }
    
    public fun create_spec(schema: vector<u8>, members: vector<vector<u8>>): SpecBlock {
        SpecBlock { schema_name: schema, member_names: members, alias_generated: true }
    }

    // Top-level function that returns a function type
    public fun get_fn_type(): |u8|u8 {
        |x: u8| {
            x + 1
        }
    }

    // Function that uses 'use' statement for importing module
    public fun use_imported_module() {
        use 0xDEAD::SubModule;
        SubModule::sub_func();
    }

    // Function to process a vector of spec blocks with a custom translate function
    public fun process_spec_blocks(specs: vector<SpecBlock>, translator: fn(SpecBlock): SpecBlock): vector<SpecBlock> {
        let result = vector::empty<SpecBlock>();
        let len = vector::length(&specs);
        let i = 0;
        while (i < len) {
            let spec = vector::borrow(&specs, i);
            let translated = translator(*spec);
            vector::push_back(&mut result, translated);
            i = i + 1;
        };
        result
    }

    // A simple translator function example
    public fun sample_translator(spec: SpecBlock): SpecBlock {
        let schema = spec.schema_name;
        // Append '_transformed' to schema name
        let new_schema = vector::copy(schema);
        vector::push_back(&mut new_schema, b"_transformed");
        SpecBlock { schema_name: new_schema, member_names: vector::copy(&spec.member_names), alias_generated: spec.alias_generated }
    }
}


//# run 0xCAFE::InteractionTest::get_fn_type


//# run 0xCAFE::InteractionTest::use_imported_module


//# run 0xCAFE::InteractionTest::create_spec --args b"Schema1" --args vector[b"member1", b"member2"]

// Prepare spec blocks vector and process

//# run 0xCAFE::InteractionTest::process_spec_blocks --args vector[spec_block, spec_block] --args sample_translator


// Featurres:
// 843cbf156cbc53e45050badafe3d2551: Define 'spec' blocks with target schemas or modules, enabling implicit aliasing of their constituent members.
// ae915a9726a36c11d4f1d384f1a96087: Allow functions to return function-typed values at the top level if the language version is at least 2.2.
// 7674a9dca6177b17be0aef022cb10f2f: Import modules in Move files using the 'use' statement.
// 3799c6bfdbc4b15df5c296f602bbe4e3: Convert a vector of specification blocks into a vector of processed specification blocks with a custom translation function.
