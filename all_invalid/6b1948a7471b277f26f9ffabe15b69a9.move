//# publish
module 0xCAFE::TestModule {
    use std::abort;

    // Dummy struct with some nested structure for testing
    struct InnerStruct {
        value: u64,
        flag: bool,
    }

    struct OuterStruct {
        inner: InnerStruct,
        label: vector<u8>,
    }

    // Enum with nested variants to test complex access
    enum MyEnum {
        VariantA { x: u128 },
        VariantB { y: bool },
        VariantC,
    }

    // Function to trigger an abort with a specific error code
    public fun trigger_abort() {
        abort 42;
    }

    // Function to access nested members and handle variants
    public fun access_nested_members() {
        // Create nested structs
        let inner = InnerStruct { value: 1000, flag: true };
        let outer = OuterStruct { inner, label: b"nested".to_vec() };

        // Access nested members
        let val = &outer.inner.value;    // 1000
        let flag = &outer.inner.flag;     // true

        // Create enum variants
        let variant_a = MyEnum::VariantA { x: 12345678901234567890 };
        let variant_b = MyEnum::VariantB { y: false };

        // Pattern match to access variants
        match variant_a {
            MyEnum::VariantA { x } => {
                // Access nested member x
                let _ = x;
            },
            _ => {},
        }

        match variant_b {
            MyEnum::VariantB { y } => {
                // Access nested member y
                let _ = y;
            },
            _ => {},
        };

        // Testing a variant with no data
        let variant_c = MyEnum::VariantC;
        match variant_c {
            MyEnum::VariantA { x } => { }, // won't match
            MyEnum::VariantB { y } => { }, // won't match
            MyEnum::VariantC => { }, // matches
        }
    }

    // Recursive function to process nodes (simulate depth-first search)
    fun process_node(node_id: u64, depth: u8): unit {
        if (depth > 10) {
            return;
        }
        // Process current node, then process "child" nodes
        let _ = node_id; // placeholder for processing
        // simulate processing child nodes
        process_node(node_id + 1, depth + 1);
        process_node(node_id + 2, depth + 1);
    }

    // Entry function to process all reachable nodes from a root
    public fun process_all_nodes() {
        process_node(1, 0);
    }
}

// //# run 0xCAFE::TestModule::trigger_abort
// This will cause a transaction to abort with code 42, testing abort functionality

// //# run 0xCAFE::TestModule::access_nested_members
// This will create nested structs, access deeply nested members, and pattern match on enum variants

// //# run 0xCAFE::TestModule::process_all_nodes
// This will execute a depth-first traversal starting from node 1, processing reachable nodes

// Featurres:
// 830c876c24f59db8f7cfb196485223b4: Abort execution using the 'abort' keyword followed by an expression to specify the abort value.
// de3429d18a9e28c8c289d73fba98caf9: Access nested members or variants with four-level name chains like '0x1::Module::Type::Variant'.
// f4b8527f89644ad222ccc503e1381f93: Process all reachable nodes from a starting entry in a depth-first manner.
