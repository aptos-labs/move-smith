//# publish
module 0x1::TestModule {
    use std::debug;
    use std::signer;

    // Spec block at top level
    // This could be a function or nested spec (represented here as a function for simplicity)
    public fun spec_top_level() {
        // Placeholder: Top-level spec logic can go here
    }

    // Function to illustrate debug logging with bytecode dump names when debug is enabled
    public fun debug_log_bytecode(names: vector<vector<u8>>) {
        let len = vector::length(&names);
        let mut i = 0;
        while (i < len) {
            // Log the bytecode name in hex
            let name = *vector::borrow(&names, i);
            debug::print(&vector::stringify(&name));
            i = i + 1;
        }
    }

    // Function to declare a literal address specifier with a byte sequence
    public fun get_literal_address() : address {
        // Using a byte sequence (0x1234) as address
        address::from_bytes(vector![0x12u8, 0x34u8])
    }

    // Function to compile a script with custom filtering (simulate by passing params)
    public fun compile_with_filter(filter_fn: fn() -> bool) {
        // Pseudo implementation: apply filter
        if (filter_fn()) {
            // Compilation logic here
            debug::print(&vector::stringify(&vector![b'Filter', b'Passed']));
        } else {
            debug::print(&vector::stringify(&vector![b'Filter', b'Failed']));
        }
    }

    // Enum Layout and iteration over its variants
    enum MyEnum {
        VariantA { value: u64 },
        VariantB { value: bool },
        VariantC { name: vector<u8> },
    }

    // Function to iterate over enum variants' fields
    public fun iterate_enum_variants(e: MyEnum) {
        match e {
            MyEnum::VariantA { value } => {
                debug::print(&vector::stringify(&vector![b'VariantA: ', b' ', vector::stringify(&value)]));
            },
            MyEnum::VariantB { value } => {
                debug::print(&vector::stringify(&vector![b'VariantB: ', b' ', vector::stringify(&value)]));
            },
            MyEnum::VariantC { name } => {
                debug::print(&vector::stringify(&vector![b'VariantC: ', b' ', vector::stringify(&name)]));
            },
        }
    }

    // Runner function to bundle some of these features for testing
    public fun run_tests() {
        // Log bytecode dump names (simulate with dummy data)
        let names = vector![
            *b"Module",
            *b"Spec",
            *b"Debug",
            *b"Address",
            *b"Filtering",
            *b"Enum"
        ];
        debug_log_bytecode(names);

        // Access literal address
        let addr = get_literal_address();
        debug::print(&vector::stringify(&vector![b'Address: ', address::to_bytes(&addr)]));
        
        // Compile with filter (simulate passing true)
        compile_with_filter(|| true);
        compile_with_filter(|| false);

        // Iterate over enum variants
        iterate_enum_variants(MyEnum::VariantA { value: 42 });
        iterate_enum_variants(MyEnum::VariantB { value: true });
        iterate_enum_variants(MyEnum::VariantC { name: *b"hello" });
    }
}

//# run 0x1::TestModule::run_tests