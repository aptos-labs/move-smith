//# publish
module 0x1::test_module {
    // Struct with custom attributes and an invariant
    struct #[attributes({ "custom": "value" })] Item has key {
        id: u64,
        owner: address,
    }

    // Struct with 'update' invariant
    struct #[attributes({ "update_invariant": "true" })] Config {
        max_items: u64,
        current_count: u64,
    }

    // Function to declare local variables with optional post state
    public fun declare_locals() {
        let x: u64 = 42;
        // declare a mutable local variable
        let mut y: bool = true;
        // declare a local variable and assign after declaration (simulate 'post' state concept)
        let z: address;
        z = @0x1;
        // re-assign y
        y = false;
        // No assertion here, just to test variable declarations
    }

    // Runner function to invoke declare_locals
    public fun run_declare_locals() {
        Self::declare_locals();
    }
}

 //# run 0x1::test_module::run_declare_locals

//# publish
module 0x1::test_module {
    // Function to create and verify struct with attributes
    public fun create_item(): Item {
        Item {
            id: 1,
            owner: @0x1,
        }
    }

    // Function to create Config with 'update' invariant
    public fun create_config(): Config {
        Config {
            max_items: 100,
            current_count: 0,
        }
    }

    // Runner to test creating structs
    public fun run_create_structs() {
        let item = Self::create_item();
        let config = Self::create_config();
    }
}

 //# run 0x1::test_module::run_create_structs