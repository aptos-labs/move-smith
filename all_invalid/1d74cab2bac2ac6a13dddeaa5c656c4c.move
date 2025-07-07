module 0xCAFE::AttributeTestModule {
    use std::vector;
    use std::debug;

    // A module to test custom attributes annotations (no actual effect but should compile)
    // test_attribute]
    struct TestStruct has copy, drop, store, key {
        dummy: u8,
    }

    // Function for testing mutable reference borrow and assignment across a loop
    public fun borrow_mut_and_loop() {
        let counter = 0u64;
        let value = 100u64;
        // Borrow a mutable reference from a local variable
        let mut_ref = &mut value;

        while (counter < 5) {
            // Modify via mutable reference
            *mut_ref = *mut_ref + counter;
            // Assign a new value to the referenced variable
            *mut_ref = *mut_ref * 2;
            counter = counter + 1;
        };
        // Return the final value for verification (not mandatory)
        value
    }

    // Function with a match statement with comma-separated arms
    public fun match_with_comma(x: u8): u8 {
        match (x) {
            0 => 10,
            1, 2 => 20,
            3 => 30,
            _ => 0,
        }
    }
}