
//# publish
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
        let_ref = &mut value;

        while (counter < 5) {
            // Modify via mutable reference
            *mut_ref = *mut_ref + counter;
            // Assign a new value to the referenced variable
            *mut_ref = *mut_ref * 2;
            counter = counter + 1;
        }
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


//# run 0xCAFE::AttributeTestModule::borrow_mut_and_loop


//# run 0xCAFE::AttributeTestModule::match_with_comma --args 0

//# run 0xCAFE::AttributeTestModule::match_with_comma --args 1

//# run 0xCAFE::AttributeTestModule::match_with_comma --args 2

//# run 0xCAFE::AttributeTestModule::match_with_comma --args 3

//# run 0xCAFE::AttributeTestModule::match_with_comma --args 99

// Featurres:
// 6935ef7afd939b6d5488225c443cee78: Define modules with custom attributes in Move.
// 9ca98640006c2bc250d521235dd91ba5: Test that a mutable reference borrowed from a local variable can be used and dropped correctly across a while loop with assignment to the referenced value.
// aea21dbc22d45e6f7964daaa7cfad30e: Separate match arms with commas, and optionally include commas between arms if the body is not a block.
